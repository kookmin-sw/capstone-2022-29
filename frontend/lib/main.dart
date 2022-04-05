// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/landing_page.dart';
import 'package:frontend/pages/more/notice_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '뉴익',
      home: NoticePage(),
    );
  }
}
