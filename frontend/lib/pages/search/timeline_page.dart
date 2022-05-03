// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/pages/home/news_page.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:timelines/timelines.dart';
import 'dart:convert';

class TimelinePage extends StatefulWidget {
  TimelinePage({Key? key, this.query, this.user_id}) : super(key: key);
  String? query;
  String? user_id;

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  double _currentSliderValue = 0;
  final timelineData =
      '[{"date": "2022.04", "content": "거리두기"},{"date": "2022.03", "content": "오미크론"},{"date": "2022.02", "content": "대유행"},{"date": "2022.01", "content": "3차 접종"}]';

  List data = [];

  Future<String> getData() async {
    // http.Response response = await http.get(
    //   Uri.encodeFull('http://jsonplaceholder.typicode.com/posts'),
    //   headers: {"Accept": "application/json"}
    // );
    data = jsonDecode(timelineData);

    return "success";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBody: true,
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        appBar: appBar(size, ' ', context, false),
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Container(child: searchBar(size, true, "")),
                                  Slider(
                                    value: _currentSliderValue,
                                    max: 4,
                                    divisions: 3,
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentSliderValue = value;
                                      });
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(198, 228, 255, 1),
                                      onPrimary: Colors.black,
                                      minimumSize: Size(
                                          size.width * 0.2, size.height * 0.05),
                                      maximumSize: Size(
                                          size.width * 0.2, size.height * 0.05),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => NavigatorPage(
                                            index: 4,
                                            query: '',
                                            user_id: widget.user_id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("검색하기"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      });
                },
                child: AbsorbPointer(
                  child: searchBar(size, false, widget.query ?? ''),
                ),
              ),
              Container(
                margin: EdgeInsets.all(size.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: size.width * 0.9,
                height: size.height * 0.6,
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: Timeline.tileBuilder(
                  builder: TimelineTileBuilder.connected(
                    indicatorBuilder: (_, index) {
                      return DotIndicator(
                          color: Color.fromRGBO(48, 105, 171, 1));
                    },
                    connectorBuilder: (_, index, connectorType) {
                      return SolidLineConnector(
                        indent: connectorType == ConnectorType.start ? 0 : 2.0,
                        endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
                        thickness: 4,
                        color: Color.fromRGBO(198, 225, 255, 1),
                      );
                    },
                    contentsAlign: ContentsAlign.basic,
                    nodePositionBuilder: (context, index) =>
                        size.width * 0.0002,
                    contentsBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(size.height * 0.02),
                        // child: Text('Timeline Event $index'),
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin:
                                      EdgeInsets.only(left: size.width * 0.03),
                                  child: Text(data[index]["date"],
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              130, 130, 130, 1))),
                                ),
                                Container(
                                  width: size.width * 0.7,
                                  height: size.height * 0.05,
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.04,
                                      right: size.width * 0.04),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data[index]["content"]),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.02,
                                              right: size.width * 0.02,
                                              top: size.height * 0.005,
                                              bottom: size.height * 0.005),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: InkWell(
                                              child: Text("바로가기"),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return NavigatorPage(
                                                        index: 3,
                                                        query: data[index]
                                                            ["content"],
                                                        user_id: widget.user_id,
                                                      );
                                                    },
                                                  ),
                                                );
                                              }))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    itemCount: data.length,
                  ),
                ),
              )
            ])));
  }
}
