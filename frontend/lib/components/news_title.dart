import 'package:flutter/material.dart';

Widget newsTitle(Size size, String query, void Function() onTap) {
  return InkWell(
    onTap: onTap,
    child: Center(
      child: Container(
        height: size.height * 0.1,
        width: size.width * 0.85,
        margin: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
        ),
        child: Text(
          query,
          style: TextStyle(
            fontSize: size.height * 0.02,
          ),
        ),
      ),
    ),
  );
}
