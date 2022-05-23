// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/more/my_keyword_page.dart';
import 'package:frontend/pages/search/detail_news_page.dart';
import 'package:frontend/pages/search/search_page.dart';
import 'package:frontend/pages/search/search_provider.dart';
import 'package:frontend/pages/splash/splash_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return SearchProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: ((context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: child!,
          );
        }),
        title: '뉴익',
        home: SplashPage(),
      ),
    );
  }
}
