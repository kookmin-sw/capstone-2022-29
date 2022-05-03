// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, must_be_immutable

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/components/button2.dart';
import 'package:timelines/timelines.dart';
import 'dart:convert';

class DetailNewsPage extends StatefulWidget {
  DetailNewsPage({Key? key, this.title}) : super(key: key);
  String? title;

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  final int num = 4;
  final int topicStep = 2;
  final similarNews = '[{"title":"유사한 뉴스 기사 1", "url":"www.naver.com"},{"title":"유사한 뉴스 기사 2", "url":"www.naver.com"},{"title":"유사한 뉴스 기사 3", "url":"www.naver.com"},{"title":"유사한 뉴스 기사 4", "url":"www.naver.com"},{"title":"유사한 뉴스 기사 5", "url":"www.naver.com"},{"title":"유사한 뉴스 기사 6", "url":"www.naver.com"}]';

  List data = [];

  Future<String> getData() async { 
    // http.Response response = await http.get( 
    //   Uri.encodeFull('http://jsonplaceholder.typicode.com/posts'), 
    //   headers: {"Accept": "application/json"}
    // ); 
    data = jsonDecode(similarNews); 
    
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
    
    void onPressed() {
      print("zz");
    }

    void closeSimilar() {
      Navigator.pop(context);
    }

    void onSimailarPressed() {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      SizedBox(
                        width: size.width * 0.9,
                        height: size.height*0.5,
                        child: ListView.builder( 
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: data == [] ? 0 : data.length, 
                          itemBuilder: (BuildContext context, int index) { 
                            print(data[index]["title"]);
                            return Container(
                              margin: EdgeInsets.only(left: size.width*0.05, right: size.width*0.05, top: size.height*0.02),
                              padding: EdgeInsets.only(left: size.width*0.05, right: size.width*0.05, top: size.height*0.02),
                              decoration: BoxDecoration(
                                // color: Color.fromRGBO(231, 243, 255, 1),
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 1.0, style:BorderStyle.solid),
                                borderRadius: BorderRadius.circular(30), 
                              ),
                              width: size.width * 0.8,
                              height: size.height * 0.07,
                              child: Text(data[index]["title"]),
                            );
                          }, 
                        ),
                      ),
                      button(size, "닫기",closeSimilar),
                    ],
                  ),
                ),
              );
            }
          );
        }
      );
    }

    return Scaffold(
      extendBody: true,
      appBar: appBar(size, widget.title, context, true, false),
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height * 0.03,
              child: Timeline.tileBuilder(
                scrollDirection: Axis.horizontal,
                builder: TimelineTileBuilder.connected(
                // fromStyle(
                  indicatorBuilder: (_, index) {
                    if (topicStep-1 == index) return DotIndicator(color: Color.fromRGBO(48, 105, 171, 1));
                    else return DotIndicator(color: Color.fromRGBO(198, 225, 255, 1));
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
                  contentsBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: size.width/(num)),
                  ),
                  itemCount: num,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: size.height*0.02),
                width: size.width * 0.8,
                height: size.height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(child: Text("대표 기사 제목 1", style: TextStyle(fontSize: 24,))),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: size.height*0.02),
                padding: EdgeInsets.only(bottom: size.height*0.02, top: size.height*0.02, left: size.width*0.05, right: size.width*0.05),
                width: size.width * 0.8,
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("마스크 대란과 관련된 대표 기사 제목 1의 요약 정리입니다."),
              ),
            ),
            buttonTwo(size, "저장하기", "원문보기", onPressed, onPressed),
            button(size, "유사한 기사 보기",onSimailarPressed),
          ],
        )
      )
    );
  }
}