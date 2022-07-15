import 'package:flutter/material.dart';
import 'package:logfin/models/customer.dart';
import 'package:logfin/models/userDetail.dart';
import 'package:logfin/screens/document_screening/certification_login.dart';
import 'package:logfin/utilities/alert.dart';
import 'package:logfin/utilities/common.dart';

import '../../utilities/custom_widget.dart';
import '../../utilities/store.dart';

class CustomerDetailPage extends StatefulWidget {
  CustomerDetailPage({Key? key}) : super(key: key);

  @override
  _CustomerDetailPageState createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  Customer customer = Store.customer;

  String? name;
  String? resFirst;
  String? resSecond;
  String? address;
  String? addr1;
  String? addr2;
  String? bank;
  String? bankCode;
  String? accountNo;
  String? accountPw;
  String? carNo;
  String? comNo;

  var agree1 = false;
  var agree2 = false;

  @override
  void initState() {
    super.initState();
  }

  Future completeButtonPressed(BuildContext context) async {
    if (!_validateValue(name)) {
      Alert.show(context: context, title: "오류", content: "이름을 입력해 주세요.");
      return;
    }

    if (!_validateValue(resFirst)) {
      Alert.show(context: context, title: "오류", content: "주민번호를 입력해 주세요.");
      return;
    }

    if (!_validateValue(resSecond)) {
      Alert.show(context: context, title: "오류", content: "주민번호를 입력해 주세요.");
      return;
    }

    if (customer.add_flg == "1") {
      if (!_validateValue(addr1)) {
        Alert.show(context: context, title: "오류", content: "주소를 입력해 주세요.");
        return;
      }
      if (!_validateValue(addr2)) {
        Alert.show(context: context, title: "오류", content: "주소를 입력해 주세요.");
        return;
      }
    }

    if (customer.com_flg == "1") {
      if (!_validateValue(comNo)) {
        Alert.show(context: context, title: "오류", content: "사업자등록번호를 입력해 주세요.");
        return;
      }
    }

    if (customer.car_flg == "1") {
      if (!_validateValue(carNo)) {
        Alert.show(context: context, title: "오류", content: "차번호를 입력해 주세요.");
        return;
      }
    }

    if (customer.bank_flg == "1") {
      if (!_validateValue(bankCode)) {
        Alert.show(context: context, title: "오류", content: "은행코드를 입력해 주세요");
        return;
      }
      if (!_validateValue(accountNo)) {
        Alert.show(context: context, title: "오류", content: "계좌번호를 입력해 주세요.");
        return;
      }
      if (!_validateValue(accountPw)) {
        Alert.show(context: context, title: "오류", content: "계좌 비밀번호를 입력해 주세요.");
        return;
      }
    }

    if (!agree1 || !agree2) {
      Alert.show(context: context, title: "오류", content: "약관을 체크해 주세요");
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CertificationLogin(
                userDetail: UserDetail(
                    name: name!,
                    addr1: addr1,
                    addr2: addr2,
                    residenceNo: resFirst! + resSecond!,
                    bankCode: bankCode,
                    accountNo: accountNo,
                    accountPw: accountPw,
                    carNo: carNo,
                    comNo: comNo))));
  }

  bool _validateValue(String? value) {
    if (value != null) {
      if (value.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.appBar(title: "인증서 로그인"),
      bottomNavigationBar:
          _bottomNavigationBar(title: "인증서서명", context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomWidget.subtitleText("고객상세정보"),
                const SizedBox(height: 25),
                _textFormFields(),
                const SizedBox(height: 25),
                _agreementsWidget()
              ]),
        ),
      ),
    );
  }

  Material _bottomNavigationBar(
      {String title = "", required BuildContext context}) {
    return Material(
      color: Colors.blueAccent,
      child: InkWell(
        onTap: () => completeButtonPressed(context),
        child: SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
                child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ))),
      ),
    );
  }

  Widget _textFormFields() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 40,
            child: TextFormField(
              maxLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                hintText: "이름",
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        hintText: "생년월일 6자리"),
                    onChanged: (value) {
                      setState(() {
                        resFirst = value;
                      });
                    },
                  ),
                ),
              ),
              const Expanded(
                  flex: 1,
                  child: Text(
                    "-",
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        hintText: '주민번호 뒷자리'),
                    onChanged: (value) {
                      setState(() {
                        resSecond = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "주민등록번호는 신용정보를 확인하여 산출 목적으로만 사용합니다.",
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
                isExpanded: true,
                value: address,
                underline: Container(color: Colors.transparent),
                hint: const Padding(
                  padding: EdgeInsets.symmetric(
                    // vertical: 10,
                    horizontal: 10,
                  ),
                  child: Text("주소 선택"),
                ),
                items: CommonConstants.REGION
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        // vertical: 10,
                        horizontal: 10,
                      ),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    address = value.toString();
                    addr1 = value.toString().split(" ")[0];
                    addr2 = value.toString().split(" ")[1];
                  });
                }),
          ),
          const SizedBox(height: 10),
          customer.com_flg == "1"
              ? SizedBox(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        hintText: '사업자등록번호'),
                    onChanged: (value) {
                      comNo = value;
                    },
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
          customer.car_flg == "1"
              ? SizedBox(
                  height: 40,
                  child: TextFormField(
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        hintText: '자동차번호'),
                    onChanged: (value) {
                      carNo = value;
                    },
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
          customer.bank_flg == "1"
              ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<String>(
                      isExpanded: true,
                      value: bank,
                      underline: Container(color: Colors.transparent),
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(
                          // vertical: 10,
                          horizontal: 10,
                        ),
                        child: Text("주거래 은행"),
                      ),
                      items: CommonConstants.BANK
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              // vertical: 10,
                              horizontal: 10,
                            ),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          bank = value.toString();
                          bankCode = value
                              .toString()
                              .split(" ")[1]
                              .replaceAll("(", "")
                              .replaceAll(")", "");
                        });
                      }),
                )
              : Container(),
          const SizedBox(height: 10),
          customer.bank_flg == "1"
              ? SizedBox(
                  height: 40,
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        hintText: '계좌번호'),
                    onChanged: (value) {
                      accountNo = value;
                    },
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
          customer.bank_flg == "1"
              ? SizedBox(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        hintText: '계좌 비밀번호'),
                    onChanged: (value) {
                      accountPw = value;
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _agreementsWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                agree1 = !agree1;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                agree1
                    ? const Icon(Icons.check_box_outlined)
                    : const Icon(Icons.check_box_outline_blank),
                const SizedBox(width: 5),
                const Text("(필수) 개인정보활용1에 동의합니다.")
              ],
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              setState(() {
                agree2 = !agree2;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                agree2
                    ? const Icon(Icons.check_box_outlined)
                    : const Icon(Icons.check_box_outline_blank),
                const SizedBox(width: 5),
                const Text("(필수) 개인정보제3자제공에 동의합니다.")
              ],
            ),
          )
        ],
      ),
    );
  }
}
