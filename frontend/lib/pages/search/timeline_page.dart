// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/models/request_model.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:timelines/timelines.dart';
import 'package:provider/provider.dart';
import 'package:frontend/pages/search/search_provider.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage(
      {Key? key, this.user_id, this.nickname, this.query, this.topicNum})
      : super(key: key);
  String? user_id;
  String? nickname;
  String? query;

  int? topicNum;

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  double _currentSliderValue = 0;
  List data = [];
  String errorMessage = "아직 해당 검색어에 대한 자료가 \n 준비되어 있지 않습니다ㅜㅅㅜ";
  bool isTopic = true;
  String query = '';
  FocusNode _focus = FocusNode();
  final _verifyKey = GlobalKey<FormState>();
  var _verify = "";
  
  String? validateSearch(FocusNode focusNode, String value) {
    if(value.isEmpty) {
      focusNode.requestFocus();
      return '검색어를 입력하세요';
    }
  }

  Widget searchInput(Size size) {
    return Form(
      key: _verifyKey,
      child: Center(
        child: SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(size.height * 0.02),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0039A4)),
                    borderRadius: BorderRadius.circular(30)),
                hintText: "주제 검색",
                hintStyle: TextStyle(color: Colors.grey[400])),
            validator: (value) => validateSearch(_focus, value!),
            onChanged: (value) {
              _verify = value;
              context.read<SearchProvider>().onChange(value);
              if (_verifyKey.currentState != null) {
                _verifyKey.currentState!.validate();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> getTopicTimeLine() async {
    List<dynamic> topicData = await ApiService().getTopic(
        Provider.of<SearchProvider>(context, listen: false).searchQuery,
        widget.topicNum.toString());
    if (topicData.isNotEmpty) {
      isTopic = true;
      for (var i = 0; i < topicData[0]["topicNum"].length; i++) {
        if (topicData[0]["topicNum"][i]["num"] == widget.topicNum) {
          print(topicData[0]["topicNum"][i]["topics"]);
          data = topicData[0]["topicNum"][i]["topics"];
          break;
        }
      }
    } else {
      isTopic = false;
      await ApiService().postRequest(Request(title: query));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    query = Provider.of<SearchProvider>(context, listen: false).searchQuery;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      appBar: appBar(size, ' ', context, true, false, () {}),
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
                                searchInput(size),
                                Slider(
                                  value: _currentSliderValue,
                                  max: 2,
                                  divisions: 2,
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
                                    if(_verifyKey.currentState!.validate()) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => NavigatorPage(
                                            index: 4,
                                            query: Provider.of<SearchProvider>(
                                                    context, listen: false)
                                                .searchQuery,
                                            user_id: widget.user_id,
                                            nickname: widget.nickname,
                                            topicNum: _currentSliderValue.toInt(),
                                          ),
                                        ),
                                      );
                                    }
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
                    size: size, color: false, value: widget.query ?? ''),
              ),
            ),
            FutureBuilder(
              future: getTopicTimeLine(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (isTopic) {
                  if (data.isNotEmpty) {
                    return Container(
                      margin: EdgeInsets.all(size.width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: size.width * 0.9,
                      height: size.height * 0.6,
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      // data.length != 0 ?
                      child: data.isNotEmpty
                          ? Timeline.tileBuilder(
                              builder: TimelineTileBuilder.connected(
                                indicatorBuilder: (_, index) {
                                  return DotIndicator(
                                      color: Color.fromRGBO(48, 105, 171, 1));
                                },
                                connectorBuilder: (_, index, connectorType) {
                                  return SolidLineConnector(
                                    indent: connectorType == ConnectorType.start
                                        ? 0
                                        : 2.0,
                                    endIndent:
                                        connectorType == ConnectorType.end
                                            ? 0
                                            : 2.0,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  left: size.width * 0.03),
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(data[index]["topic"]),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              size.width * 0.02,
                                                          right:
                                                              size.width * 0.02,
                                                          top: size.height *
                                                              0.005,
                                                          bottom: size.height *
                                                              0.005),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: InkWell(
                                                          child: Text("바로가기"),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return NavigatorPage(
                                                                    index: 3,
                                                                    isSearch:
                                                                        true,
                                                                    query: widget
                                                                        .query,
                                                                    topic: data[
                                                                            index]
                                                                        [
                                                                        "topic"],
                                                                    news: data[
                                                                            index]
                                                                        [
                                                                        "news"],
                                                                    user_id: widget
                                                                        .user_id,
                                                                    nickname: widget
                                                                        .nickname,
                                                                    topicNum: data
                                                                        .length,
                                                                    topicStepNum:
                                                                        index +
                                                                            1,
                                                                    topicName: data[index]["topic"],
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
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Text(errorMessage,
                                      style: TextStyle(fontSize: 18))
                                ]),
                    );
                  } else {
                    return SizedBox(
                      height: size.height * 0.6,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                } else {
                  return SizedBox(
                    height: size.height * 0.6,
                    child: Center(
                      child: Text(
                        '$query의 토픽 데이터가 아직 없어요ㅜㅅㅜ\n관리자에게 추가 요청할게요!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
