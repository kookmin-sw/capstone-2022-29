// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

Widget buttonTwo(Size size, String name1, String name2){
  return Container(
    margin: EdgeInsets.only(top:size.height*0.03),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            minimumSize: Size(size.width*0.35, size.height*0.05),
            maximumSize: Size(size.width*0.35, size.height*0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: (){}, 
          child: Text(name1),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(198, 228, 255, 1),
            onPrimary: Colors.black,
            minimumSize: Size(size.width*0.35, size.height*0.05),
            maximumSize: Size(size.width*0.35, size.height*0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: ()=>{}, 
          child: Text(name2),
        ),
      ],
    ),
  );
}