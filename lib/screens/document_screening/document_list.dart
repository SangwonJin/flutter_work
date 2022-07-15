import 'package:flutter/material.dart';
import 'package:logfin/models/customer.dart';
import 'package:logfin/models/userDetail.dart';
import 'package:logfin/utilities/api_manager.dart';
import 'package:logfin/utilities/common.dart';

import '../../utilities/custom_widget.dart';
import '../../utilities/store.dart';

class DocumentList extends StatefulWidget {
  final String password;
  final UserDetail userDetail;
  const DocumentList(
      {Key? key, required this.password, required this.userDetail})
      : super(key: key);

  @override
  _DocumentListState createState() => _DocumentListState(password, userDetail);
}

class _DocumentListState extends State<DocumentList> {
  String password;
  UserDetail userDetail;
  _DocumentListState(this.password, this.userDetail);

  Customer customer = Store.customer;

  void checkStatusAfter() {
    for (var i = 0; i < customer.documents.length; i++) {
      if (customer.documents[i].status == "완료") {
      } else {
        setState(() {
          customer.documents[i].isLoading = true;
        });
        Map<String, String> params = {
          "test_api_key": CommonConstants.testApiKey,
          "name": customer.name,
          "pfx": Store.pfx,
          "pw": password,
          "rno": userDetail.residenceNo,
          "loan_document_id": customer.documents[i].id,
          "addr1": userDetail.addr1 ?? "",
          "addr2": userDetail.addr2 ?? "",
          "bank_code": userDetail.bankCode ?? "",
          "account_no": userDetail.accountNo ?? "",
          "account_pw": userDetail.accountPw ?? "",
          "car_no": userDetail.carNo ?? "",
          "com_no": userDetail.comNo ?? "",
        };

        ApiManager.checkStatus(customer.documents[i].method_name, params)
            .then((value) {
          setState(() {
            customer.documents[i].status = (value == "CF-00000" ? "완료" : "실패");
            customer.documents[i].isLoading = false;
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidget.appBar(title: "인증서 로그인"),
        bottomNavigationBar: CustomWidget.bottomNavigationBar(
            title: "완료",
            onPressed: () {
              checkStatusAfter();
            }),
        body: SizedBox(
          height: MediaQuery.of(context).size.height +
              MediaQuery.of(context).padding.bottom,
          child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
              child: _documentsList()),
        ));
  }

  Widget _documentsList() {
    return ListView.builder(
        itemCount: customer.documents.length,
        itemBuilder: (context, index) {
          List<Document> docs = customer.documents;
          return _documentTile(doc: docs[index], status: docs[index].status);
        });
  }

  Widget _documentTile({required Document doc, required String status}) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(doc.name)),
          _statusWidget(status: status, loading: doc.isLoading)
        ],
      ),
    );
  }

  Widget _statusWidget({required String status, required bool loading}) {
    if (status == "완료") {
      return Text(status);
    } else {
      if (loading) {
        return const SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ));
      } else {
        return Text(status);
      }
    }
  }
}
