import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logfin/screens/import_certificate/certificate_password.dart';
import 'package:logfin/utilities/alert.dart';
import 'package:logfin/utilities/bridge_manager.dart';
import 'package:logfin/utilities/custom_widget.dart';

class ImportCertificate extends StatefulWidget {
  const ImportCertificate({Key? key}) : super(key: key);

  @override
  _ImportCertificateState createState() => _ImportCertificateState();
}

class _ImportCertificateState extends State<ImportCertificate> {
  var androidAuthNumber = "            ";

  Future completeButtonPressed() async {
    Alert.loading(context: context, title: "잠시만 기다려 주세요");

    if (Platform.isIOS) {
      await BridgeManager.requestImport();
    } else {
      var result = await BridgeManager.requestImport();
      Navigator.pop(context);
      if (result) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CertificatePassword()),
        );
      } else {
        Alert.show(context: context, title: "오류", content: "실패하였습니다.");
      }
    }
  }

  Future requestAuthNumberPressed() async {
    if (Platform.isIOS) {
      await BridgeManager.requestAuthNumberIOS();
    } else if (Platform.isAndroid) {
      await getAndroidAuthNumber();
    } else {
      print("Not mobile platform");
    }
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      getAndroidAuthNumber();
    } else {
      BridgeManager.requestAuthNumberIOS();
    }
    super.initState();
  }

  Future getAndroidAuthNumber() async {
    var value = await BridgeManager.requestAuthNumberAndroid();
    setState(() {
      androidAuthNumber = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return StreamBuilder(
          stream: BridgeManager.onImportCertificateIOS,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Navigator.pop(context);
              if (snapshot.data.toString() == "1") {
                return const CertificatePassword();
              } else {
                Future.delayed(
                    Duration.zero,
                    () => Alert.show(
                        context: context, title: "오류", content: "실패하였습니다."));
              }
            } else {}
            return Scaffold(
                appBar: CustomWidget.appBar(title: "심사 서류"),
                bottomNavigationBar: CustomWidget.bottomNavigationBar(
                    onPressed: completeButtonPressed),
                body: _body());
          });
    } else {
      return Scaffold(
          appBar: CustomWidget.appBar(title: "심사 서류"),
          bottomNavigationBar: CustomWidget.bottomNavigationBar(
              onPressed: completeButtonPressed),
          body: _body());
    }
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CustomWidget.titleText("공동인증서 가져오기"),
            const SizedBox(height: 15),
            _detailText(),
            const SizedBox(height: 30),
            _stepOne(),
            const SizedBox(height: 15),
            _stepTwo(),
            const SizedBox(height: 15),
            _stepThree(),
            const SizedBox(height: 15),
            _authNumberWidget(),
          ],
        ),
      ),
    );
  }

  Widget _detailText() {
    return const Text(
      "다음과 같은 순서대로 PC에 있는 공동인증서를 휴대폰으로 복사해주세요.",
      style: TextStyle(fontSize: 15),
    );
  }

  Widget _stepOne() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Expanded(
            flex: 1,
            child: Text(
              "1.",
              style: TextStyle(fontSize: 12),
            )),
        Expanded(
            flex: 14,
            child: Text(
                "공동인증서가 있는 PC에서 https://www.logfin.kr/cert_copy에 접속합니다. \n(Mac 인 경우 safari 브라우저에 가능함)",
                style: TextStyle(fontSize: 12))),
      ],
    );
  }

  Widget _stepTwo() {
    return Row(
      children: const <Widget>[
        Expanded(flex: 1, child: Text("2.", style: TextStyle(fontSize: 12))),
        Expanded(
            flex: 14,
            child:
                Text("'공동인증서 복사하기'를 클릭합니다.", style: TextStyle(fontSize: 12))),
      ],
    );
  }

  Widget _stepThree() {
    return Row(
      children: const <Widget>[
        Expanded(flex: 1, child: Text("3.", style: TextStyle(fontSize: 12))),
        Expanded(
            flex: 14,
            child: Text("공동인증서 로그인 후 아래 인증 번호를 입력합니다.",
                style: TextStyle(fontSize: 12))),
      ],
    );
  }

  Widget _authNumberWidget() {
    if (Platform.isIOS) {
      return StreamBuilder(
          stream: BridgeManager.onAuthNumber,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var num = snapshot.data.toString();
              var first = num.substring(0, 4);
              var second = num.substring(4, 8);
              var third = num.substring(8, 12);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomWidget.authBox(first),
                  CustomWidget.authDash(),
                  CustomWidget.authBox(second),
                  CustomWidget.authDash(),
                  CustomWidget.authBox(third),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomWidget.authBox("####"),
                  CustomWidget.authDash(),
                  CustomWidget.authBox("####"),
                  CustomWidget.authDash(),
                  CustomWidget.authDash(),
                  CustomWidget.authBox("####"),
                ],
              );
            }
          });
    } else if (Platform.isAndroid) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomWidget.authBox(androidAuthNumber.substring(0, 4)),
          CustomWidget.authDash(),
          CustomWidget.authBox(androidAuthNumber.substring(4, 8)),
          CustomWidget.authDash(),
          CustomWidget.authBox(androidAuthNumber.substring(8, 12)),
        ],
      );
    } else {
      return Container();
    }
  }
}
