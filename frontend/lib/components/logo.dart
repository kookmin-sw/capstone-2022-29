import 'package:flutter/material.dart';

Widget logo(Size size) {
  return Container(
    margin: EdgeInsets.only(
      left: size.width * 0.02,
      top: size.height * 0.03,
    ),
    width: size.width * 0.3,
    child: Image.asset('lib/assets/images/logo_mini.png'),
  );
}
