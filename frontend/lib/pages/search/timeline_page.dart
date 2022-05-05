// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:timelines/timelines.dart';
import 'package:provider/provider.dart';
import 'package:frontend/pages/search/search_provider.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({Key? key, this.query, this.user_id, this.topicNum}) : super(key: key);
  String? query;
  String? user_id;
  int? topicNum;

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  double _currentSliderValue = 0;
  List data = [];
  String errorMessage = "아직 해당 검색어에 대한 자료가 \n 준비되어 있지 않습니다ㅜㅅㅜ";

  Future<void> getTopicTimeLine() async {
    // List<dynamic> topicData = await ApiService().getTopic(widget.query, widget.topicNum.toString());
    List<dynamic> topicData = await ApiService().getTopic("코로나", widget.topicNum.toString());
    if (topicData.length != 0) {
      for (var i=0;i<topicData[0]["topicNum"].length;i++){
        if (topicData[0]["topicNum"][i]["num"] == widget.topicNum){
          print(topicData[0]["topicNum"][i]["topics"]);
          data = topicData[0]["topicNum"][i]["topics"];
          break;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBody: true,
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        appBar: appBar(size, ' ', context, true, false),
        body: SafeArea(
            child: FutureBuilder(
              future: getTopicTimeLine(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Column(
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
                                      searchBar(
                                        size: size, 
                                        color: true, 
                                        value: ""
                                      ),
                                      Slider(
                                        value: _currentSliderValue,
                                        max: 3,
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
                                                query: Provider.of<SearchProvider>(context).searchQuery,
                                                user_id: widget.user_id,
                                                topicNum : _currentSliderValue.toInt(),
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
                      child: searchBar(
                        size: size, 
                        color: false, 
                        value:  widget.query ?? ''
                      ),
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
                    // data.length != 0 ?
                    child: data.isNotEmpty ? Timeline.tileBuilder(
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
                                          Text(data[index]["topic"]),
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
                                                    print(data[index]["news"]);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return NavigatorPage(
                                                            index: 3,
                                                            isSearch: true,
                                                            query: data[index]["topic"],
                                                            news : data[index]["news"],
                                                            user_id: widget.user_id,
                                                            topicNum: data.length,
                                                            topicStepNum: index+1,
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
                    ) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children : [Text(errorMessage, style: TextStyle(fontSize: 18))],
                    ),
                  )
                ]);
              }
            )));
  }
}
