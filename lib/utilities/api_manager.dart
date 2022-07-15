import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:logfin/models/customer.dart';
import 'package:logfin/utilities/common.dart';
import 'package:logfin/utilities/store.dart';

class ApiManager {
  static const String baseUrl = "";
  static const String mUrl = "";
  static Map<String, dynamic> defaultResponse = {
    "isError": false,
    "message": "",
    "data": ""
  };

  // ======== 고객 정보를 가져옵니다 ===========
  static Future<Customer?> getCustomerInfo() async {
    // var url = Uri.parse('$baseUrl/getloan/iV02ENBpBi6fjwMYvnq6Ig.json');
    var url = Uri.parse('$baseUrl/getloan/${Store.uid}.json');

    var response = await http.get(url);
    var data = await decodeJsonInBackground(response.body);

    if (data["status"] == 404) {
      return null;
    }

    List<Document> documents = data["documents"]
        .map<Document>((value) => Document(
            id: value["id"].toString(),
            name: value["document"]["name"],
            complete: value["complete"].toString(),
            method_name: value["document"]["method_name"],
            document: value["document"],
            status: value["complete"].toString() == "1" ? "완료" : "대기",
            isLoading: false))
        .toList();

    Customer customer = Customer(
        name: data["customer_name"],
        birthday: data["customer_birthday"].toString(),
        com_flg: data["com_flg"].toString(),
        car_flg: data["car_flg"].toString(),
        bank_flg: data["bank_flg"].toString(),
        add_flg: data["addr_flg"].toString(),
        documents: documents);
    Store.customer = customer;
    return customer;
  }

  // ======== 서류 완료 여부를 확인합니다 ===========
  static Future<String> checkStatus(
      String method_name, Map<String, String> params) async {
    var uri = Uri.https(mUrl, "/app_${method_name}.json", params);

    var response = await http.post(uri);
    var data = await decodeJsonInBackground(response.body);
    return data["result"]["code"];
  }

  // ======== 토큰을 가져옵니다 ===========
  static Future<String> getToken(String clientId, String secretKey) async {
    // Oauth2.0 사용자 자격증명 방식(client_credentials) 토큰 요청 설정
    var params = {"grant_type": "client_credentials", "scope": "read"};

    var url = Uri.https(
        CommonConstants.TOKEN_DOMAIN, CommonConstants.GET_TOKEN, params);
    // "grant_type=client_credentials&scope=read";

    // 클라이언트아이디, 시크릿코드 Base64 인코딩
    String auth = clientId + ":" + secretKey;

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String authStringEnc =
        stringToBase64.encode(auth); // dXNlcm5hbWU6cGFzc3dvcmQ=
    String authHeader = "Basic " + authStringEnc;
    // try {} catch (e) {}
    var response = await http.post(url, headers: {
      HttpHeaders.authorizationHeader: authHeader,
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    var data = await decodeJsonInBackground(response.body);
    return data["access_token"];
  }

  // ======== 여러 Request를 한번에 실행하려면 사용합니다 ===========
  static Future<List<String>> concurrenceStatus(
      {required List<Future<http.Response>> list, required int length}) async {
    List<String> result = [];
    var response = await Future.wait(list);

    for (int i = 0; i < length; i++) {
      var data = await decodeJsonInBackground(response[i].body);
      if (data["result"]["code"] == "CF-00000") {
        result.add("완료");
      } else {
        result.add("실패");
      }
    }
    return result;
  }

  // ======== RUN CODE WITH ISOLATE ( has its own memory ) to avoid app lagging.
  static Future<dynamic> decodeJsonInBackground(dynamic responseBody) async {
    return compute(backgroundTask, responseBody);
  }

  static Future<dynamic> backgroundTask(dynamic responseBody) async {
    // every code inside this function will run in an isolate.
    return await json.decode(responseBody);
  }
}
