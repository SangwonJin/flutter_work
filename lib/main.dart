import 'package:flutter/material.dart';
import 'package:logfin/screens/initial/app_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogFin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: const AppWrapper(),
    );
  }
}
