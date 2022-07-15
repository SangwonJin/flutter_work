import 'package:flutter/material.dart';
import 'package:logfin/screens/document_screening/customer_detail.dart';
import 'package:logfin/screens/import_certificate/import_certificate.dart';
import 'package:logfin/screens/credit_certification/nice_webview.dart';
import 'package:logfin/utilities/alert.dart';
import 'package:logfin/utilities/bridge_manager.dart';

import '../../utilities/custom_widget.dart';
import '../../utilities/store.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  bool isLoading = false;

  // ======== 확인 버튼 클릭 ===========
  Future checkDocumentButtonPressed(BuildContext context) async {
    Alert.loading(context: context, title: "잠시만 기다려 주세요");
    await _checkCertificate();
  }

  // ======== 인증서 존재 확인 ===========
  Future _checkCertificate() async {
    await BridgeManager.setCertificates();
    Navigator.pop(context);
    if (Store.certificates.isEmpty) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ImportCertificate()));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerDetailPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidget.appBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // _applicationInfoTitle(title: "대출접수 정보"),
                      CustomWidget.subtitleText("대출접수 정보"),
                      _applicationInfoDetail(),
                      const SizedBox(height: 10),
                      _creditVerificationTitle(title: "1. 신용인증"),
                      _creditVerificationSubtitle(
                          content: "NICE 신용평가에서 제공하는 신용접수를 확인합니다."),
                      _creditVerificationButton(title: "바로가기"),
                      const SizedBox(height: 10),
                      _documentExaminationTitle(title: "2. 심사서류"),
                      _docmentExaminationSubtitle(
                          content:
                              "공동인증서를 기관 로그인을 진행하고, 건강보험공단 홈택스, 민원24 등 각종 공공기관에서의 정보를 가져옵니다."),
                      _documentExaminationButton(
                          title: "바로가기", context: context)
                    ]),
              ),

              // CustomerWidgit.loadingView()
            ],
          ),
        ));
  }

  Widget _applicationInfoDetail() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text("- 신청일: 2021년 12월 24일 오후 3시15분"),
          const SizedBox(height: 5),
          const Text("- 접수번호: logfin-1004"),
          const SizedBox(height: 5),
          Text("- 고객명: ${Store.customer.name}"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _creditVerificationTitle({String title = ""}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _creditVerificationSubtitle({String content = ""}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const Text("NICE 신용평가에서 제공하는 신용접수를 확인합니다."),
    );
  }

  Widget _creditVerificationButton({String title = ""}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NiceWebView(),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(), backgroundColor: Colors.blue),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _documentExaminationTitle({String title = ""}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }

  Widget _docmentExaminationSubtitle({String content = ""}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(content),
    );
  }

  Widget _documentExaminationButton(
      {String title = "", required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: OutlinedButton(
          onPressed: () async {
            await checkDocumentButtonPressed(context);
          },
          style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(), backgroundColor: Colors.blue),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          )),
    );
  }
}
