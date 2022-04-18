// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/components/slide_news/slide.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:bubble_chart/bubble_chart.dart';


final Color backgroundColor = Color(0xFFf7f7f7);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenHeight=0.0, screenWidth = 0.0;
  final Duration duration = const Duration(milliseconds: 300);
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _menuScaleAnimation;
  late final Animation<Offset> _slideAnimation;
  List<BubbleNode> childNode = [];

  @override
  void initState() {
    super.initState();
     _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
    _addNewNode();
  }

  _addNewNode() {
    setState(() {
      Random random = Random();
      BubbleNode node = BubbleNode.leaf(
        value: max(1, random.nextInt(10)),
        options: BubbleOptions(
          color: () {
            Random random = Random();
            return Colors.primaries[random.nextInt(Colors.primaries.length)];
          }(),
        ),
      );
      node.options?.onTap = () {
        setState(() {
          node.value += 1;
          // childNode.remove(node);
        });
      };
      childNode.add(node);
    });
  }

  List data = [
    {"query": "코로나", "count": 20},
    {"query": "우크라이나", "count": 50},
    {"query": "국민대학교", "count": 10},
    {"query": "메타버스", "count": 15},
  ];

  List<BubbleNode> getData(Size size) {
    List<BubbleNode> list = [];
    for (var i = 0; i < data.length; i++) {
      list.add(
        BubbleNode.node(
          padding: 10,
          children: [
            BubbleNode.leaf(
              value: data[i]["count"],
              options: BubbleOptions(
                color: () {
                  Random random = Random();
                  return Colors
                      .primaries[random.nextInt(Colors.primaries.length)]
                      .shade100;
                  // return Gradient.linear(
                  //     const Offset(0, 20), const Offset(150, 20), <Color>[
                  //   Colors.white,
                  //   Colors.primaries[random.nextInt(Colors.primaries.length)],
                  // ]);
                }(),
                child: Container(
                  padding: EdgeInsets.all(size.height * 0.01),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      data[i]["query"],
                      style: TextStyle(
                        fontSize: size.height * 0.01 * data[i]["count"],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          options: BubbleOptions(color: Colors.transparent),
        ),
      );
    }
    return list;
  }

  Widget bubbleChart(Size size) {
    return SizedBox(
      height: size.height * 0.3,
      child: BubbleChartLayout(
        children: getData(size),
      ),
    );
  }

  List<Widget> getSlide(Size size) {
    List<Widget> list = [];
    list.add(bubbleChart(size));
    for (var i = 0; i < data.length; i++) {
      list.add(
        slide(
          context,
          size,
          data[i]["query"],
        ),
      );
    }
    return list;
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
      backgroundColor: isCollapsed? Color(0xfff7f7f7): Color(0xFFe7f3ff),
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
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
                            index: 6,
                          );
                        },
                      ),
                    );
                  }
                ),
                SizedBox(height:40),
                InkWell(
                  child: Text("Q&A", style: TextStyle(color: Colors.black, fontSize: 20)),
                  onTap: () { 
                    _controller.forward();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NavigatorPage(
                            index: 8,
                          );
                        },
                      ),
                    );
                  }
                ),
                SizedBox(height:40),
                InkWell(
                  child: Text("나의 키워드", style: TextStyle(color: Colors.black, fontSize: 20)),
                  onTap: () { 
                    _controller.forward();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NavigatorPage(
                            index: 9,
                          );
                        },
                      ),
                    );
                  }
                ),  
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AnimatedPositioned(
        duration: duration,
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : 0.6 * screenWidth,
        right: isCollapsed ? 0 : -0.2 * screenWidth,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            animationDuration: duration,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: backgroundColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: SafeArea(
                child: Container(
                padding: EdgeInsets.only(left: size.width*0.05, right: size.width*0.05, top: size.height * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: logo(size),
                      onTap: () {
                        setState(() {
                          if (isCollapsed)
                            _controller.forward();
                          else
                            _controller.reverse();
    
                          isCollapsed = !isCollapsed;
                        });
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NavigatorPage(
                                index: 1,
                              );
                            },
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        child: searchBar(size, false,""),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.67,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getSlide(size),
                        )
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}