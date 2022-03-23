// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xff5964E1),
      body: SafeArea(
        child: Center(
          child: Text(
            "Search Page",
            style: TextStyle(
              color: Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}
