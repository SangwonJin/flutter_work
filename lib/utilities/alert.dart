import 'package:flutter/material.dart';

class Alert {
  static Future<void> show(
      {required BuildContext context,
      required String title,
      required String content,
      String buttonTitle = "확인"}) {
    var width = MediaQuery.of(context).size.width;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Center(
              child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Text(content),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: width,
                  color: Colors.blue,
                  child: Text(
                    buttonTitle,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> status({
    required BuildContext context,
    required Widget content,
    required String title,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, snapshot) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              padding: const EdgeInsets.only(top: 10),
              child: content,
            ),
          );
        });
      },
    );
  }

  static Future<void> loading({
    required BuildContext context,
    required String title,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, snapshot) {
          return AlertDialog(
            title: Center(
                child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            )),
            content: Container(
              height: 150,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: const SizedBox(
                height: 100,
                width: 100,
                child:
                    Center(child: CircularProgressIndicator(strokeWidth: 6.0)),
              ),
            ),
          );
        });
      },
    );
  }
}
