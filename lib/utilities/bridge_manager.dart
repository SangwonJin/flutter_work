import 'package:flutter/services.dart';
import 'package:logfin/models/certificate.dart';

import 'store.dart';

class BridgeManager {
  static const method = MethodChannel("Bridge");
  static const event = EventChannel("co.auth-number.key");
  static const deepLinkEvent = EventChannel("com.deep-link.uid");
  static const importCertEvent = EventChannel("com.import-certificate.key");

  // ======== iOS AuthNumber 리스너 ===========
  static Stream get onAuthNumber {
    return event.receiveBroadcastStream("onAuth");
  }

  // ======== iOS DeepLinkUid 리스너 ===========
  static Stream get onDeepLinkUid {
    return deepLinkEvent.receiveBroadcastStream();
  }

  // ======== iOS ImportCertificate 리스너 ===========
  static Stream get onImportCertificateIOS {
    return importCertEvent.receiveBroadcastStream("onImport");
  }

  // ======== 딥링크를 통해 uid 가져옵니다. ===========
  static Future<String> getDeepLink() async {
    var result = await method.invokeMethod("Get_DeepLink_UID");
    return result;
  }

  // ======== 토큰 설정합니다 ===========
  static Future setToken() async {
    await method.invokeMethod("Set_Token", {"token": Store.token});
  }

  // ======== iOS Auth Number 요청합니다 ===========
  static Future requestAuthNumberIOS() async {
    await method.invokeMethod("Request_Auth_Number");
  }

  // ======== Android Auth Number 요청합니다 ===========
  static Future<String> requestAuthNumberAndroid() async {
    var result = await method.invokeMethod("Request_Auth_Number");
    return result["authNumber"];
  }

  // ======== 인증서 요청합니다 ===========
  static Future<bool> requestImport() async {
    var result = await method.invokeMethod("Request_Import");
    return result;
  }

  // ======== 인증서 요청 완료 처리합니다. ===========
  static Future<Map<String, dynamic>> completeImportCertification(
      String password) async {
    var value = await method
        .invokeMethod("Complete_Import_Certification", {"password": password});
    var result = {"code": value["code"], "msg": value["msg"]};
    return result;
  }

  // static Future<List<Certificate>> getCertificates() async {
  //   var result = await method.invokeListMethod("Get_Certificates");
  //   List<Certificate> certificates = result!
  //       .map((res) => Certificate(
  //           certName: res["certName"],
  //           derBase64: res["derBase64"],
  //           expireTime: res["expireTime"],
  //           keyBase64: res["keyBase64"],
  //           policyId: res["policyId"],
  //           serialNumber: res["serialNumber"]))
  //       .toList();
  //   Store.certificates = certificates;
  //   return certificates;
  // }

  // ======== 디바이스에서 존재하는 인증서를 가져옵니다. ===========
  static Future<bool> getCertificates() async {
    print("Get_Certificate");
    var result = await method.invokeListMethod("Get_Certificates");
    List<Certificate> certificates = result!
        .map((res) => Certificate(
            certName: res["certName"],
            derBase64: res["derBase64"],
            expireTime: res["expireTime"],
            keyBase64: res["keyBase64"],
            policyId: res["policyId"],
            serialNumber: res["serialNumber"]))
        .toList();
    Store.certificates = certificates;
    return certificates.isNotEmpty;
  }

  // ======== 디바이스에서 존재하는 인증서를 가져오고 스토어에 저장합니다. ===========
  static Future setCertificates() async {
    print("Set_Certificate");
    var result = await method.invokeListMethod("Get_Certificates");
    print("result : ${result}");
    List<Certificate> certificates = result!
        .map((res) => Certificate(
            certName: res["certName"],
            derBase64: res["derBase64"],
            expireTime: res["expireTime"],
            keyBase64: res["keyBase64"],
            policyId: res["policyId"],
            serialNumber: res["serialNumber"]))
        .toList();
    Store.certificates = certificates;
  }

  // ======== License 체크합니다 ===========
  static Future<bool> checkLicense() async {
    var result = await method.invokeMethod("Check_License");
    print(result);
    return result;
  }

  // ======== 디바이스에서 존재하는 인증서의 비밀번호를 확인합니다. ===========
  static Future checkCertificatePassword(
      String password,
      Certificate certificate,
      Function(String pfxBase64) onSuccess,
      Function(String msg) onFailed) async {
    var result = await method.invokeMethod("Certificate_Password_Check", {
      "password": password,
      "derBase64": certificate.derBase64,
      "keyBase64": certificate.keyBase64
    });
    print("Flutter checkCertificatePassword => $result");

    if (result["status"] == 0) {
      onFailed("Failed to verify the certificate password");
    } else {
      Store.pfx = result["pfxBase64"];
      onSuccess(result["pfxBase64"]);
    }
  }

  // ======== 디바이스에서 존재하는 인증서를 삭제합니다. ===========
  static Future<Map<String, dynamic>> deleteCertificate(
      {required String certName}) async {
    var value = await method
        .invokeMethod("Delete_Certification", {"certName": certName});
    print("${certName} deletion result : ${value}");
    var result = {"code": value["code"], "msg": value["msg"]};
    return result;
  }
}
