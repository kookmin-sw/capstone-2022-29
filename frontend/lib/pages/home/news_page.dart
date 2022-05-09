// ignore_for_file: prefer_const_constructors, prefer_is_empty,must_be_immutable, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/news_title.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/models/bubble_model.dart';

class NewsPage extends StatefulWidget {
  NewsPage(
      {Key? key,
      this.news,
      this.query,
      this.topic,
      this.user_id,
      this.topicNum,
      this.topicStepNum})
      : super(key: key);
  List<dynamic>? news;
  String? query;
  String? topic;
  String? user_id;
  int? topicNum;
  int? topicStepNum;

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
        List<dynamic> news =
            await ApiService().getNewsID(widget.news![i]["news_id"]);

        setState(() {
          data.add({
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
                      news_id: widget.news![i]["news_id"],
                      topicNum: widget.topicNum,
                      topicStepNum: widget.topicStepNum,
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

  Future<void> requestMore(dynamic query) async {
    List<dynamic> news = await ApiService().getNews(query, nextPage, perPage);
    setState(() {
      for (var i = 0; i < news.length; i++) {
        data.add({
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
                          return newsTitle(size, data[index]['title'],
                              data[index]['navigate']);
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
