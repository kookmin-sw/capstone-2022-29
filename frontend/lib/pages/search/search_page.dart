// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/components/search_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            logo(size),
            searchBar(size),
          ],
        ),
      ),
    );
  }
}
