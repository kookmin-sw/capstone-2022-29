// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

Widget colorList(BuildContext context, String title, String content){
  Size size = MediaQuery.of(context).size;
  return Container(
    child: Column(
      children: [
        Container(
          child: Text(title, maxLines:1, overflow: TextOverflow.ellipsis),
          width: size.width,    
          height: 35,
          decoration: BoxDecoration(
            color: Color.fromRGBO(198, 228, 255, 1),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
            )
          ),
          padding: EdgeInsets.fromLTRB(20,10,20,0),
        ),
        Container(
          child: Text(content, maxLines:2, overflow: TextOverflow.ellipsis),
          width: size.width,    
          height: 60,
          decoration: BoxDecoration(
            color: Color.fromRGBO(247, 247, 247, 1),
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(30),
              bottomRight: const Radius.circular(30),
            )
          ),
          padding: EdgeInsets.fromLTRB(20,10,20,0),
        ),
      ]
    ),
    margin: EdgeInsets.fromLTRB(20,15,20,5),
    decoration: BoxDecoration(),
  );
}