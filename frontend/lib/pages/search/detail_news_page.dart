// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/components/button2.dart';
import 'package:frontend/models/bookmark_model.dart';
// import 'package:timelines/timelines.dart';
import 'package:provider/provider.dart';
import 'package:frontend/pages/search/search_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:percent_indicator/percent_indicator.dart';

class DetailNewsPage extends StatefulWidget {
  DetailNewsPage(
      {Key? key,
      this.user_id,
      this.nickname,
      this.news_id,
      this.topicNum,
      this.topicStepNum,
      this.query,
      this.topicName})
      : super(key: key);
  String? user_id;
  String? nickname;
  String? news_id;
  int? topicNum;
  int? topicStepNum;
  String? query;
  String? topicName;

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  List<dynamic> data = [];

  Future<void> getNews() async {
    data.clear();
    data = await ApiService().getNewsID(widget.news_id);
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    final int num = widget.topicNum ?? 0;
    final int topicStep = widget.topicStepNum ?? 0;
    Size size = MediaQuery.of(context).size;
    String query =
        widget.query ?? Provider.of<SearchProvider>(context, listen: false).searchQuery;

    Future<void> postBookmark(String user_id) async {
      List<dynamic> isBookmark = await ApiService().getBookmark(user_id);
      if (isBookmark.isEmpty) {
        await ApiService().postBookmark(
          Bookmark(
            user_id: user_id,
            bookmarks: Bookmarks(
              news_id: widget.news_id!,
              query: query,
              topic: "",
            ),
          ),
        );
      } else {
        await ApiService().updateBookmark(
          user_id,
          Bookmark(
            user_id: user_id,
            bookmarks: Bookmarks(
              news_id: widget.news_id!,
              query: query,
              topic: "",
            ),
          ),
        );
      }
    }

    void onSharePressed() {
      String title = data.isNotEmpty ? data[0]["title"] : '';
      String summary = data.isNotEmpty ? data[0]["summary"] : '';
      Share.share('[$query]$title\n$summary', subject: '뉴익 $widget.news_id');
    }

    void onShowPressed() async {
      Uri url = Uri.parse(data[0]["url"]);
      if (!await launchUrl(url)) throw 'Could not launch $url';
    }

    void closeSimilar() {
      Navigator.pop(context);
    }

    void onConfirmDialog() {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
                content: SizedBox(
                    height: size.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.topicNum != null
                            ? '북마크가 정상적으로 등록되었습니다.'
                            : '북마크가 이미 등록되어 있습니다.'),
                        button(size, "닫기", closeSimilar),
                      ],
                    )));
          });
    }

    void onSavePressed() async {
      if (widget.topicNum != null) await postBookmark(widget.user_id!);
      onConfirmDialog();
    }

    // void onSimailarPressed() {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: true,
    //     builder: (context) {
    //       return StatefulBuilder(
    //           builder: (BuildContext context, StateSetter setState) {
    //         return AlertDialog(
    //           content: SingleChildScrollView(
    //             child: ListBody(
    //               children: <Widget>[
    //                 SizedBox(
    //                   width: size.width * 0.9,
    //                   height: size.height * 0.5,
    //                   child: ListView.builder(
    //                     scrollDirection: Axis.vertical,
    //                     shrinkWrap: true,
    //                     itemCount: data == [] ? 0 : data.length,
    //                     itemBuilder: (BuildContext context, int index) {
    //                       return Container(
    //                         margin: EdgeInsets.only(
    //                             left: size.width * 0.05,
    //                             right: size.width * 0.05,
    //                             top: size.height * 0.02),
    //                         padding: EdgeInsets.only(
    //                             left: size.width * 0.05,
    //                             right: size.width * 0.05,
    //                             top: size.height * 0.02),
    //                         decoration: BoxDecoration(
    //                           color: Colors.white,
    //                           border: Border.all(
    //                               color: Colors.black,
    //                               width: 1.0,
    //                               style: BorderStyle.solid),
    //                           borderRadius: BorderRadius.circular(30),
    //                         ),
    //                         width: size.width * 0.8,
    //                         height: size.height * 0.07,
    //                         child: Text(data[index]["title"]),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //                 button(size, "닫기", closeSimilar),
    //               ],
    //             ),
    //           ),
    //         );
    //       });
    //     });
    // }
    return Scaffold(
        extendBody: true,
        appBar: appBar(size, query, context, true, true, onSharePressed),
        backgroundColor: Color(0xffF7F7F7),
        body: SafeArea(
            child: FutureBuilder(
                future: getNews(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (data.isNotEmpty) {
                    return Column(
                      children: [
                        widget.topicNum != null
                            ? SizedBox(
                                width: size.width * 0.9,
                                height: size.height * 0.03,
                                child: Slider(
                                  value: (topicStep-1)/(num-1),
                                  max: 1,
                                  onChanged: (double value) {
                                  },
                                ),
                              )
                            : Container(),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: size.height * 0.02, bottom: size.height*0.02),
                            width: size.width * 0.8,
                            padding: EdgeInsets.only(top: size.height*0.015, bottom: size.height*0.015, left: size.width*0.05, right: size.width*0.05),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(data[0]['title'],
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                )
                              )
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: size.width*0.8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: size.height*0.005, bottom: size.height*0.005, left: size.width*0.02, right: size.width*0.02),
                                    margin: EdgeInsets.only(left: size.width*0.01, right: size.width*0.01),
                                    child: Text(data[0]['date']),
                                    decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromARGB(255, 19, 17, 17),
                                        width: size.width * 0.0025,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: size.height*0.005, bottom: size.height*0.005, left: size.width*0.02, right: size.width*0.02),
                                    margin: EdgeInsets.only(left: size.width*0.02, right: size.width*0.02),
                                    child: Text(data[0]['journal']),
                                    decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xff000000),
                                        width: size.width * 0.0025,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  widget.topicName != ''? Container(
                                    padding: EdgeInsets.only(top: size.height*0.005, bottom: size.height*0.005, left: size.width*0.02, right: size.width*0.02),
                                    margin: EdgeInsets.only(left: size.width*0.02, right: size.width*0.02),
                                    child: Text(widget.topicName??''),
                                    decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xff000000),
                                        width: size.width * 0.0025,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ):Container(),
                                ],
                              ),
                            )
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: size.height * 0.02),
                            padding: EdgeInsets.only(
                                bottom: size.height * 0.02,
                                top: size.height * 0.02,
                                left: size.width * 0.05,
                                right: size.width * 0.05),
                            width: size.width * 0.8,
                            height: size.height * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: SingleChildScrollView(child: Text(data[0]['summary'])),
                          ),
                        ),
                        buttonTwo(
                            size, "저장하기", "원문보기", onSavePressed, onShowPressed),
                        // button(size, "유사한 기사 보기", onSimailarPressed),
                      ],
                    );
                  } else {
                    return Container();
                  }
                })));
  }
}
