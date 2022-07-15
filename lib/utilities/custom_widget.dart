import 'package:flutter/material.dart';

class CustomWidget {
  static Widget titleText(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    );
  }

  static Widget subtitleText(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  static Widget linkText(
      {required String title, required VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.blue))),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  static AppBar appBar({String title = "로그핀"}) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blueAccent,
      elevation: 0.0,
      centerTitle: true,
    );
  }

  static Widget bottomNavigationBar(
      {String title = "확인", required VoidCallback onPressed}) {
    return Material(
      color: Colors.blueAccent,
      child: InkWell(
        onTap: onPressed,
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

  static Widget authBox(String authNum) {
    return Expanded(
        flex: 3,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            authNum,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ));
  }

  static Widget authDash({String dash = "-"}) {
    return Expanded(
        flex: 1,
        child: Text(
          dash,
          textAlign: TextAlign.center,
        ));
  }
}
