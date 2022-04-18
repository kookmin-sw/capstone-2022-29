// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/pages/home/home_page.dart';
import 'package:frontend/pages/navigator.dart';
class MorePage extends StatefulWidget {
  MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> with SingleTickerProviderStateMixin{
  bool isCollapsed = false;
  double screenHeight=0.0, screenWidth = 0.0;
  final Duration duration = const Duration(milliseconds: 300);
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.6).animate(_controller);

  }

@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
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
            InkWell(
              child: Text("공지사항", style: TextStyle(color: Colors.black, fontSize: 20)),
              onTap: () { 
                _controller.forward();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NavigatorPage(
                        index: 7,
                      );
                    },
                  ),
                );
              }
            ),
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
      left: isCollapsed? 0: 0.6 * screenWidth,
      right: isCollapsed? 0: -0.4 * screenWidth,
      // height: screenHeight*0.8,
      child: InkWell(
        onTap: () {
          print('zz');
          _controller.forward();
          Navigator.pop(context);
        },
        child: Container(
          child: HomePage(), 
          height: screenHeight * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}