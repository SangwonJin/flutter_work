import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class NiceWebView extends StatefulWidget {
  const NiceWebView({Key? key}) : super(key: key);

  @override
  _NiceWebViewState createState() => _NiceWebViewState();
}

class _NiceWebViewState extends State<NiceWebView> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebView"),
      ),
      body: const WebView(
        initialUrl: "",
      ),
    );
  }
}
