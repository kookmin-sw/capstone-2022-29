// ignore_for_file: prefer_const_constructors, prefer_is_empty,must_be_immutable, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/list_color.dart';
import 'package:frontend/components/news_title.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/models/bubble_model.dart';

class NewsPage extends StatefulWidget {
  NewsPage(
      {Key? key,
      this.user_id,
      this.nickname,
      this.news,
      this.query,
      this.topic,
      this.topicNum,
      this.topicStepNum,
      this.topicName})
      : super(key: key);
  String? user_id;
  String? nickname;
  List<dynamic>? news;
  String? query;
  String? topic;

  int? topicNum;
  int? topicStepNum;
  String? topicName;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final perPage = 10;
  bool isMoreRequesting = false;
  int nextPage = 1;
  double _dragDistance = 0;

  List<Map> data = [];

  @override
  void initState() {
    super.initState();
    requestNew(widget.query);
  }

  Future<void> addBubble(
      dynamic user_id, dynamic news_id, dynamic query, dynamic topic) async {
    List<dynamic> allBubble = await ApiService().getBubbleUserId(user_id);
    if (allBubble.length == 0) {
      await ApiService().postBubble(
        Bubble(user_id: user_id, bubbles: Bubbles(query: query, count: 1)),
      );
    } else {
      List<dynamic> bubble = await ApiService().getBubble(user_id, query);
      if (bubble.length == 0) {
        await ApiService().updateNewBubble(
          user_id,
          Bubble(user_id: user_id, bubbles: Bubbles(query: query, count: 0)),
        );
      } else {
        await ApiService().updateBubbleCount(
          user_id,
          query,
          Bubble(user_id: user_id, bubbles: Bubbles(query: query, count: 0)),
        );
      }
    }
  }

  //스크롤 이벤트 처리
  scrollNotification(notification) {
    // 스크롤 최대 범위
    var containerExtent = notification.metrics.viewportDimension;

    if (notification is ScrollStartNotification) {
      _dragDistance = 0;
    } else if (notification is OverscrollNotification) {
      _dragDistance -= notification.overscroll;
    } else if (notification is ScrollUpdateNotification) {
      _dragDistance -= notification.scrollDelta!;
    } else if (notification is ScrollEndNotification) {
      var percent = _dragDistance / (containerExtent);
      if (percent <= -0.4) {
        if (notification.metrics.maxScrollExtent ==
            notification.metrics.pixels) {
          setState(() {
            isMoreRequesting = true;
          });

          requestMore(widget.query).then((value) {
            setState(() {
              isMoreRequesting = false;
            });
          });
        }
      }
    }
  }

  Future<void> requestNew(dynamic query) async {
    nextPage = 1;
    data.clear();

    if (widget.news?.length == 0) {
      List<dynamic> news = await ApiService().getNews(query, nextPage, perPage);

      setState(() {
        for (var i = 0; i < news.length; i++) {
          data.add({
              'date': news[i]['date'],
            'title': news[i]['title'],
            'navigate': () async {
              Uri url = Uri.parse(news[i]['url']);
              if (!await launchUrl(url)) throw 'Could not launch $url';
            }
          });
        }
        nextPage += 1;
      });
    } else {
      for (var i = 0; i < widget.news!.length; i++) {
        List<dynamic> news = await ApiService().getNewsID(widget.news![i]["news_id"]);

        if (mounted){
          setState(() {
            data.add({
              'date': news[0]['date'],
              'title': news[0]["title"],
              'url': news[0]["url"],
              'summary': news[0]["summary"],
              'navigate': () async {
                await addBubble(widget.user_id, widget.news![i]["news_id"],
                    widget.query, query);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NavigatorPage(
                        index: 5,
                        user_id: widget.user_id,
                        nickname: widget.nickname,
                        news_id: widget.news![i]["news_id"],
                        topicNum: widget.topicNum,
                        topicStepNum: widget.topicStepNum,
                        topicName: widget.topicName,
                      );
                    },
                  ),
                );
              },
            });
          });
        }
      }
    }
  }

  Future<void> requestMore(dynamic query) async {
    List<dynamic> news = await ApiService().getNews(query, nextPage, perPage);
    setState(() {
      for (var i = 0; i < news.length; i++) {
        // print(news[i]['date']);
        data.add({
          // 'date': news[i]['date'],
          'title': news[i]['title'],
          'navigate': () async {
            Uri url = Uri.parse(news[i]['url']);
            if (!await launchUrl(url)) throw 'Could not launch $url';
          }
        });
      }
      nextPage += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: appBar(size, '${widget.query} 뉴스', context, true, false, () {}),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: size.height * 0.7,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    scrollNotification(notification);
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () => requestNew(widget.query),
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index < data.length) {
                          return InkWell(
                            onTap: data[index]['navigate'],
                            child: Container(
                              child: Column(children: [
                                Container(
                                  child: Text(data[index]['date']??'',maxLines: 1, overflow: TextOverflow.ellipsis),
                                  width: size.width,
                                  height: size.height * 0.04,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(198, 228, 255, 1),
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(40.0),
                                        topRight: const Radius.circular(40.0),
                                      )),
                                  padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height*0.01, size.width * 0.05, 0),
                                ),
                                Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data[index]['title'], maxLines: 2, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                    width: size.width,
                                    height: size.height * 0.06,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: const Radius.circular(30),
                                          bottomRight: const Radius.circular(30),
                                        )),
                                    padding: EdgeInsets.fromLTRB(
                                        size.width * 0.05, 0, size.width * 0.05, 0),
                                  ),
                              ]),
                              margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02,
                                  size.width * 0.05, size.height * 0.01),
                              decoration: BoxDecoration(),
                            ),
                          );
                        } else {
                          return isMoreRequesting
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
