// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/pages/landing_page.dart';
import 'package:flutter_application/pages/login_page.dart';
import 'package:flutter_application/pages/navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black, // Color for Android
        statusBarBrightness: Brightness.light, // for IOS.
      ),
    );
    return MaterialApp(
      title: 'Smishing',
      home: NavigatorPage(),
    );
  }
}
