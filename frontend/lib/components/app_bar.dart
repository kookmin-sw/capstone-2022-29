// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: Image.asset('lib/assets/images/backIcon.png', width: 31, height: 31,),
      onPressed: null,
    ),
    title: Container(
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      width: 165,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    centerTitle: true,
    elevation: 0.0,
  );
}