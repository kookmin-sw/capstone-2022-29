// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/pages/splash/splash_page.dart';
import 'package:frontend/pages/more/my_keyword_page.dart';
import 'package:frontend/pages/more/notice_detail_page.dart';
import 'package:frontend/pages/more/notice_page.dart';
import 'package:frontend/pages/more/qna_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late ThemeModeNotifier _themeModeNotifier;
  late final WidgetsBinding _widgetsBinding;
  late final FlutterWindow _window;

  @override
  void initState() {
    _widgetsBinding = WidgetsBinding.instance!;
    _widgetsBinding.addObserver(this);
    _window = _widgetsBinding.window;
    _themeModeNotifier = ThemeModeNotifier(
      ValueNotifier<Brightness>(_window.platformDispatcher.platformBrightness),
    );
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    _themeModeNotifier.changeBrightness(
      brightness: _window.platformDispatcher.platformBrightness,
    );
    super.didChangePlatformBrightness();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: _themeModeNotifier.appBrightness,
      builder: (context, value, child) {
        return MaterialApp(
          title: '뉴익',
          theme: ThemeData(
            brightness: value,
          ),
          home: SplashPage(),
        );
      },
    );
  }
}

class ThemeModeNotifier {
  ThemeModeNotifier(this.appBrightness);

  final appBrightness;

  changeBrightness({required Brightness brightness}) {
    appBrightness.value = brightness;
  }
}
