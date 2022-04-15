// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_final_fields

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/components/slide_news/slide.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:bubble_chart/bubble_chart.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BubbleNode> childNode = [];

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Color(0xffF7F7F7),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 가로
            mainAxisAlignment: MainAxisAlignment.start, // 세로
            children: [
              logo(size),
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
                  child: searchBar(size, false),
                ),
              ),
              SizedBox(
                height: size.height * 0.67,
                child: ListView(
                  shrinkWrap: true,
                  children: getSlide(size),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
