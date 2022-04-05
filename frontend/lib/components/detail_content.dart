// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget detailContent(BuildContext context, String content){
  Size size = MediaQuery.of(context).size;
  return Container(
    width: size.width,    
    height: 400,
    child: SingleChildScrollView(child:Text(content)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
    padding: EdgeInsets.fromLTRB(15, 15, 15, 15)
  );
}