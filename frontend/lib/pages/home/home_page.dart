// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, non_constant_identifier_names, must_be_immutable, prefer_typing_uninitialized_variables
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/components/slide_news/slide.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:bubble_chart/bubble_chart.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/api/kakao_signin_api.dart';
import 'package:frontend/pages/login/login_page.dart';

final Color backgroundColor = Color(0xFFf7f7f7);

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.nickname, this.user_id, this.method, this.random})
      : super(key: key);
  String? nickname;
  String? user_id;
  String? method;
  Random? random;

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
  var userInfo;
  bool isBubble = true;
  bool isKeyword = true;

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
      BubbleNode node = BubbleNode.leaf(
        value: max(1, widget.random!.nextInt(10)),
        options: BubbleOptions(
          color: () {
            return Colors
                .primaries[widget.random!.nextInt(Colors.primaries.length)];
          }(),
        ),
      );
      node.options?.onTap = () {
        setState(() {
          node.value += 1;
        });
      };
      childNode.add(node);
    });
  }

  List<Map> dataBubble = [];
  List<String> dataKeyword = [];

  Future<void> getBubble(dynamic user_id) async {
    dataBubble.clear();

    List<dynamic> bubble = await ApiService().getBubbleUserId(user_id);
    if (bubble.isNotEmpty) {
      isBubble = true;
      for (var i = 0; i < bubble.length; i++) {
        for (var j = 0; j < bubble[i]['bubble'].length; j++) {
          dataBubble.add({
            'query': bubble[i]['bubble'][j]['query'],
            'count': bubble[i]['bubble'][j]['count']
          });
        }
      }
      dataBubble.sort(((a, b) => (b['count']).compareTo(a['count'])));
    } else {
      isBubble = false;
    }
  }

  Future<void> getKeyword(dynamic user_id) async {
    dataKeyword.clear();

    List<dynamic> keywordList = await ApiService().getKeyword(user_id);
    if (keywordList.isNotEmpty) {
      isKeyword = true;
      for (var i = 0; i < keywordList.length; i++) {
        for (var j = 0; j < keywordList[i]['keywords'].length; j++) {
          dataKeyword.add(keywordList[i]['keywords'][j]['keyword']);
        }
      }
    } else {
      isKeyword = false;
    }
  }

  Future<void> getUser(dynamic nickname) async {
    userInfo = await ApiService().getUserInfo(nickname);
  }

  List<BubbleNode> getData(Size size) {
    List<BubbleNode> list = [];
    for (var i = 0; i < dataBubble.length; i++) {
      list.add(
        BubbleNode.node(
          padding: 10,
          children: [
            BubbleNode.leaf(
              value: dataBubble[i]["count"],
              options: BubbleOptions(
                color: () {
                  Random random = Random();
                  return Colors
                      .primaries[random.nextInt(Colors.primaries.length)]
                      .shade100;
                }(),
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        dataBubble[i]["query"],
                        style: TextStyle(
                          fontSize: size.height * 0.01 * dataBubble[i]["count"],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NavigatorPage(
                          index: 3,
                          query: dataBubble[i]["query"],
                          user_id: widget.user_id,
                          nickname: widget.nickname,
                        ),
                      ),
                    );
                  },
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
    return BubbleChartLayout(
      children: getData(size),
    );
  }

  List<Widget> getSlide(Size size) {
    List<Widget> list = [];
    // list.add(bubbleChart(size));
    for (var i = 0; i < dataKeyword.length; i++) {
      list.add(
        slide(
          isCollapsed,
          context,
          size,
          dataKeyword[i],
          widget.user_id!,
          widget.nickname!,
        ),
      );
    }
    return list;
  }

  Future<void> _logout() async {
    debugPrint('kakao logout');
    await KakaoSignInAPI.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
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
              child: FutureBuilder(
                  future: getUser(widget.nickname),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (userInfo != null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.25,
                                height: screenWidth * 0.25,
                                child: Image.network(userInfo["profile"]),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(userInfo["nickname"]),
                              Text("[뉴스를 익히다]",
                                  style: TextStyle(color: Color(0xff4B3187))),
                              SizedBox(height: screenHeight * 0.04),
                              InkWell(
                                  child: SizedBox(
                                    width: screenWidth * 0.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.list_outlined),
                                            SizedBox(width: screenWidth * 0.02),
                                            Text("공지사항",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16)),
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
                                            user_id: widget.user_id,
                                            nickname: widget.nickname,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.person_outline),
                                            SizedBox(width: screenWidth * 0.02),
                                            Text("Q&A",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16)),
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
                                            user_id: widget.user_id,
                                            nickname: widget.nickname,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.favorite_border_outlined),
                                          SizedBox(width: screenWidth * 0.02),
                                          Text("나의 키워드",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16)),
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
                                          user_id: widget.user_id,
                                          nickname: widget.nickname,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screenHeight * 0.3),
                            ],
                          ),
                          InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.logout_outlined),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text("로그아웃",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                ],
                              ),
                              onTap: () {
                                _logout();
                              }),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
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
                    top: size.height * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: logo(size),
                        onTap: () {
                          setState(() {
                            if (isCollapsed) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }

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
                                  user_id: widget.user_id,
                                  nickname: widget.nickname,
                                );
                              },
                            ),
                          );
                        },
                        child: AbsorbPointer(
                          child: searchBar(size: size, color: false, value: ""),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.66,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: getBubble(widget.user_id),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (isBubble) {
                                    if (dataBubble.isNotEmpty) {
                                      return SizedBox(
                                        height: size.height * 0.3,
                                        child: bubbleChart(size),
                                      );
                                    } else {
                                      return SizedBox(
                                        height: size.height * 0.3,
                                        child: Center(
                                          child: Text(
                                            "궁금한 뉴스를 검색해 보세요!",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                              FutureBuilder(
                                future: getKeyword(widget.user_id),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (isKeyword) {
                                    if (dataKeyword.isNotEmpty) {
                                      return Column(
                                        children: getSlide(size),
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: Text(
                                        "나만의 키워드를 만들어 보세요!",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
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
