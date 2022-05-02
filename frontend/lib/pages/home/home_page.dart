// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/components/slide_news/slide.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:bubble_chart/bubble_chart.dart';
import 'package:localstorage/localstorage.dart';
import 'package:frontend/api/api_service.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';

final Color backgroundColor = Color(0xFFf7f7f7);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenHeight = 0.0, screenWidth = 0.0;
  final Duration duration = const Duration(milliseconds: 300);
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _menuScaleAnimation;
  late final Animation<Offset> _slideAnimation;
  List<BubbleNode> childNode = [];
  final LocalStorage localStorage = LocalStorage('user');

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    _addNewNode();
    super.initState();
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

  List<Map> data = [];

  Future<void> getBubble(dynamic user_id) async {
    // print("user_id = ${user_id}");
    data.clear();
    List<dynamic> bubble = await ApiService().getBubbleUserId(user_id);
    for (var i = 0; i < bubble.length; i++) {
      for (var j = 0; j < bubble[i]['bubble'].length; j++) {
        data.add({
          'query': bubble[i]['bubble'][j]['query'],
          'count': bubble[i]['bubble'][j]['count']
        });
      }
    }
    data.sort(((a, b) => (b['count']).compareTo(a['count'])));
  }

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
      backgroundColor: isCollapsed ? Color(0xfff7f7f7) : Color(0xFFe7f3ff),
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
          padding: EdgeInsets.only(
              top: screenHeight * 0.1,
              bottom: screenHeight * 0.05,
              left: screenWidth * 0.05),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.25,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // child: Image.network(userProfileImagePath ?? '')
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text('최혜원'),
                    Text("[뉴스를 익히다]",
                        style: TextStyle(color: Color(0xff4B3187))),
                    SizedBox(height: screenHeight * 0.04),
                    InkWell(
                        child: SizedBox(
                          width: screenWidth * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.list_outlined),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text("공지사항",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: screenWidth * 0.04),
                            ],
                          ),
                        ),
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
                        }),
                    SizedBox(height: screenHeight * 0.02),
                    InkWell(
                        child: SizedBox(
                          width: screenWidth * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person_outline),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text("Q&A",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: screenWidth * 0.04),
                            ],
                          ),
                        ),
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
                        }),
                    SizedBox(height: screenHeight * 0.02),
                    InkWell(
                        child: SizedBox(
                          width: screenWidth * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.favorite_border_outlined),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text("나의 키워드",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: screenWidth * 0.04),
                            ],
                          ),
                        ),
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
                        }),
                  ],
                ),
                InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.logout_outlined),
                        SizedBox(width: screenWidth * 0.02),
                        Text("로그아웃",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                    onTap: () {}),
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
                  padding: EdgeInsets.only(
                      left: size.width * 0.05,
                      right: size.width * 0.05,
                      top: size.height * 0.01),
                  child: FutureBuilder(
                    future: getBubble(localStorage.getItem('user_id')),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (data.isNotEmpty) {
                        return Column(
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
                                child: searchBar(size, false, ""),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.67,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: getSlide(size),
                                  )),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
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
