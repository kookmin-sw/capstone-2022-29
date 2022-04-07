// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        child: Center(
          child: Text("Bookmark Page"),
        ),
      ),
    );
  }
}
