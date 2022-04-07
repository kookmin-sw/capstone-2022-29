// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

Widget searchBar(Size size) {
  return Center(
    child: Container(
      height: size.height * 0.065,
      width: size.width * 0.9,
      margin: EdgeInsets.only(
        top: size.height * 0.01,
        bottom: size.height * 0.01,
      ),
      child: OutlineSearchBar(
        backgroundColor: Color(0xffffffff),
        borderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        cursorColor: Colors.black,
        searchButtonIconColor: Colors.black,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
        ),
        onKeywordChanged: (String value) {
          // debugPrint(value);
        },
        onSearchButtonPressed: (String value) {
          debugPrint("submit: $value");
        },
      ),
    ),
  );
}
