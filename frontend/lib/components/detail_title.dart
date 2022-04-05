import 'package:flutter/material.dart';

Widget detailTitle(BuildContext context, String title){
  Size size = MediaQuery.of(context).size;
  return Container(
    width: size.width,    
    height: 40,
    child: Center(child: Text(title)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
  );
}