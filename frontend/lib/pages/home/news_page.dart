// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/news_title.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key, this.query}) : super(key: key);
  String? query;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<String> data = <String>[
    '뉴스 제목1',
    '뉴스 제목2',
    '뉴스 제목3',
    '뉴스 제목4',
    '뉴스 제목5',
  ];

  List<Widget> getNewsList(Size size) {
    List<Widget> list = [];
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: appBar(size, '${widget.query} 뉴스', context),
      body: SafeArea(
        child: SizedBox(
          height: size.height * 0.67,
          child: ListView(
            shrinkWrap: true,
            children: getNewsList(size),
          ),
        ),
      ),
    );
  }
}
