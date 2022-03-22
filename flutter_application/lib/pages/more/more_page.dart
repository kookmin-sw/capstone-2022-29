// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xff5964E1),
      body: SafeArea(
        child: Center(
          child: Text("More Page"),
        ),
      ),
    );
  }
}
