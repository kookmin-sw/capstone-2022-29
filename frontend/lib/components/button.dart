// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

Widget button(Size size, String name, Function func){
  return Container(
    margin: EdgeInsets.only(top:size.height*0.02),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(198, 228, 255, 1),
        onPrimary: Colors.black,
        minimumSize: Size(size.width*0.65, size.height*0.05),
        maximumSize: Size(size.width*0.65, size.height*0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: (){func();}, 
      child: Text(name),
    )
  );
}