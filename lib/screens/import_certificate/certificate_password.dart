import 'package:flutter/material.dart';
import 'package:logfin/screens/document_screening/customer_detail.dart';
import 'package:logfin/utilities/alert.dart';
import 'package:logfin/utilities/bridge_manager.dart';

import '../../utilities/custom_widget.dart';

class CertificatePassword extends StatefulWidget {
  const CertificatePassword({Key? key}) : super(key: key);

  @override
  _CertificatePasswordState createState() => _CertificatePasswordState();
}

class _CertificatePasswordState extends State<CertificatePassword> {
  var password = "";
  var cool = "";

  Future completeButtonPressed() async {
    Alert.loading(context: context, title: "잠시만 기다려 주세요");
    var res = await BridgeManager.completeImportCertification(password);
    Navigator.pop(context);
    if (res["code"] == 0) {
      Alert.show(context: context, title: "", content: "성공하였습니다")
          .then((value) async {
        var result = await BridgeManager.getCertificates();
        if (result) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => CustomerDetailPage()));
        } else {
          //TODO: Show Alert! Can't get Certificate
        }
      });
    } else {
      Alert.show(
          context: context,
          title: "",
          content: "실패 ${res["code"]}: ${res["msg"]} ");
    }
  }

  Widget _passwordTextfield() {
    return TextFormField(
      obscureText: true,
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
      maxLines: 1,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          hintText: '비밀번호'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.appBar(title: "공동인증서 비밀번호"),
      bottomNavigationBar:
          CustomWidget.bottomNavigationBar(onPressed: completeButtonPressed),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text("인증서 비밀번호"),
              _passwordTextfield(),
            ],
          ),
        ),
      ),
    );
  }
}
