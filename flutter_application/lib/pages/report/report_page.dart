// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text("Report Page"),
        ),
      ),
    );
  }
}
