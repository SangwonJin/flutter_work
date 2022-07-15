import 'package:flutter/material.dart';
import 'package:logfin/utilities/custom_widget.dart';

enum Gender { male, female, undefined }

class CreditCertification extends StatefulWidget {
  const CreditCertification({Key? key}) : super(key: key);

  @override
  _CreditCertificationState createState() => _CreditCertificationState();
}

class _CreditCertificationState extends State<CreditCertification> {
  String? username;
  String? userContact;
  String? userBirthday;
  var userGender = Gender.undefined;

  Widget _usernameTextfield() {
    return TextFormField(
      // obscureText: true,
      onChanged: (value) {
        setState(() {
          // password = value;
          username = value;
        });
      },
      maxLines: 1,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          hintText: '고객명'),
    );
  }

  Widget _contactTextfield() {
    return TextFormField(
      // obscureText: true,
      onChanged: (value) {
        setState(() {
          // password = value;
          userContact = value;
        });
      },
      maxLines: 1,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          hintText: '연락처'),
    );
  }

  Widget _birthdayTextfield() {
    return TextFormField(
      // obscureText: true,
      onChanged: (value) {
        setState(() {
          // password = value;
          userBirthday = value;
        });
      },
      maxLines: 1,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          hintText: '생년월일'),
    );
  }

  Widget _genderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: InkWell(
          onTap: () {
            setState(() {
              userGender = Gender.male;
            });
          },
          child: Row(
            children: <Widget>[
              if (userGender == Gender.male)
                const Icon(Icons.radio_button_on)
              else
                const Icon(Icons.radio_button_off),
              const Text("남자"),
            ],
          ),
        )),
        Expanded(
            child: InkWell(
          onTap: () {
            setState(() {
              userGender = Gender.female;
            });
          },
          child: Row(
            children: <Widget>[
              if (userGender == Gender.female)
                const Icon(Icons.radio_button_on)
              else
                const Icon(Icons.radio_button_off),
              const Text("여자"),
            ],
          ),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.appBar(title: "공동인증서 비밀번호"),
      bottomNavigationBar: CustomWidget.bottomNavigationBar(onPressed: () {}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "신용인증정보",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 20),
              // _passwordTextfield(),
              _usernameTextfield(),
              const SizedBox(height: 10),
              _contactTextfield(),
              const SizedBox(height: 10),
              _birthdayTextfield(),
              const SizedBox(height: 10),
              _genderSelection(),
            ],
          ),
        ),
      ),
    );
  }
}
