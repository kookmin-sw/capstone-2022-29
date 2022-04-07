// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:flutter/material.dart';

Widget cardNews(Size size, String journal, String title) {
  return Center(
    child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.03,
            width: size.width * 0.3,
            decoration: BoxDecoration(
              color: Color(0xffC6E4FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "$journal",
                style: TextStyle(
                  fontSize: size.width * 0.035,
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.12,
            width: size.width * 0.3,
            decoration: BoxDecoration(
              color: Color(0xffF7F7F7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "$title",
                style: TextStyle(
                  fontSize: size.width * 0.035,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
