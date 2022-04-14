// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/pages/home/home_page.dart';
import 'package:frontend/pages/more/notice_page.dart';

class MorePage extends StatelessWidget {
  // const MorePage({Key? key}) : super(key: key);
  bool isCollapsed = true;
  double screenHeight=0.0, screenWidth = 0.0;
  final Duration duration = const Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(231, 243, 255, 1),
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ]
      )
    );
  }

  Widget menu (context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("공지사항", style: TextStyle(color: Colors.black, fontSize: 20)),
            SizedBox(height:40),
            Text("Q&A", style: TextStyle(color: Colors.black, fontSize: 20)),
            SizedBox(height:40),
            Text("나의 키워드", style: TextStyle(color: Colors.black, fontSize: 20)),
          ]
        ),
      ),
    );
  }

  Widget dashboard(context){
    return AnimatedPositioned(
      duration: duration,
      top: 0.1 * screenHeight,
      bottom: 0.1 * screenHeight,
      left: 0.6 * screenWidth,
      right: -0.4 * screenWidth,
      child: Container(
        child: NoticePage(), 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}