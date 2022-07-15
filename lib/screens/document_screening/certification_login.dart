import 'package:flutter/material.dart';
import 'package:logfin/models/certificate.dart';
import 'package:logfin/models/userDetail.dart';
import 'package:logfin/screens/document_screening/document_list.dart';
import 'package:logfin/screens/import_certificate/import_certificate.dart';
import 'package:logfin/utilities/alert.dart';
import 'package:logfin/utilities/bridge_manager.dart';

import '../../utilities/custom_widget.dart';
import '../../utilities/store.dart';

class CertificationLogin extends StatefulWidget {
  final UserDetail userDetail;
  const CertificationLogin({Key? key, required this.userDetail})
      : super(key: key);

  @override
  _CertificationLoginState createState() =>
      _CertificationLoginState(userDetail);
}

class _CertificationLoginState extends State<CertificationLogin> {
  UserDetail userDetail;
  _CertificationLoginState(this.userDetail);

  int? selectedIndex;
  var password = "";

  List<Certificate> certificates = Store.certificates;

  @override
  void initState() {
    super.initState();
  }

  Future completeButtonPressed() async {
    if (selectedIndex != null) {
      Alert.loading(context: context, title: "잠시만 기다려 주세요");
      await BridgeManager.checkCertificatePassword(
          password, certificates[selectedIndex!], (pfxBase64) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DocumentList(password: password, userDetail: userDetail)));
      }, (msg) {
        Navigator.pop(context);
        Alert.show(context: context, title: "오류", content: msg);
      });
    } else {
      Alert.show(context: context, title: "오류", content: "인증서를 선택해 주세요.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.appBar(title: "인증서 로그인"),
      bottomNavigationBar:
          CustomWidget.bottomNavigationBar(onPressed: completeButtonPressed),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _certificatesList(),
                const SizedBox(height: 30),
                CustomWidget.subtitleText("공동인증서"),
                const SizedBox(height: 5),
                _certificatePasswordTextfield(),
                const SizedBox(height: 20),
                CustomWidget.linkText(
                  title: "본인 명의로 등록 된 인증서가 없나요?",
                  onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ImportCertificate()),
                    );
                  },
                ),
                // _deleteCertButton()
              ]),
        ),
      ),
    );
  }

  Widget _deleteCertButton() {
    return OutlinedButton(
        onPressed: () async {
          await BridgeManager.deleteCertificate(
              certName: Store.certificates[selectedIndex!].certName);
        },
        style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(), backgroundColor: Colors.grey),
        child: const Text(
          "Delete",
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget _certificatesList() {
    return ListView.separated(
      itemCount: certificates.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return _certificateListTile(index);
      },
    );
  }

  Widget _certificateListTile(int index) {
    return ListTile(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      tileColor: selectedIndex == index ? Colors.blueAccent : Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(0),
      title: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              color: Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    certificates[index].certName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "범용기업/정보인증",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "만료일: ${certificates[index].expireTime}",
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _certificatePasswordTextfield() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '공동인증서 비밀번호 입력',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
      ),
    );
  }
}
