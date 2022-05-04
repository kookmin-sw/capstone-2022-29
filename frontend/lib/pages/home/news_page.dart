// ignore_for_file: prefer_const_constructors, prefer_is_empty,must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/news_title.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key, this.query, this.user_id}) : super(key: key);
  String? query;
  String? user_id;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<String> data = [];
  List<Widget> list = [];

  List<Widget> getNewsList(Size size) {
    for (var i = 0; i < data.length; i++) {
      list.add(
        newsTitle(
          size,
          data[i],
        ),
      );
    }
    return list;
  }

  Future<void> getNews(dynamic query) async {
    data.clear();
    List<dynamic> news = await ApiService().getNews(query);
    // print("page: ${news.length}");
    for (var i = 0; i < news.length; i++) {
      data.add(news[i]['title']);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: appBar(size, '${widget.query} 뉴스', context, true, false),
      body: SafeArea(
        child: FutureBuilder(
          future: getNews(widget.query),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (data.length != 0) {
              return SizedBox(
                height: size.height * 0.75,
                child: ListView(
                  shrinkWrap: true,
                  children: getNewsList(size),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
