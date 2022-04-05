// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        child: Center(
          child: Text(
            "Home Page",
            style: TextStyle(
              color: Color(0xff000000),
            ),
          ),
        ),
      ),
    );
  }
}
