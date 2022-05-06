// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/list_color.dart';
import 'package:frontend/api/api_service.dart';

class BookmarkPage extends StatefulWidget {
  BookmarkPage({Key? key, this.user_id}) : super(key: key);
  String? user_id;

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map> data = [];

  Future<void> getBookmark(dynamic user_id) async {
    data.clear();
    List<dynamic> bookmark = await ApiService().getBookmark(user_id);
    for (var i = 0; i < bookmark.length; i++) {
      for (var j = 0; j < bookmark[i]['bookmark'].length; j++) {
        data.add({
          'news_id': bookmark[i]['bookmark'][j]['news_id'],
          'news_title': bookmark[i]['bookmark'][j]['news_id'],
          'query': bookmark[i]['bookmark'][j]['query']
        });
      }
    }
    for (var i = 0; i < data.length; i++) {
      await getNewsTitle(data[i]['news_title'], i);
    }
  }

  Future getNewsTitle(dynamic news_id, int i) async {
    List<dynamic> news = await ApiService().getNewsID(news_id);
    data[i]['news_title'] = news[0]['title'];
  }

  Future<void> deleteBookmark(dynamic user_id, dynamic news_id) async {
    await ApiService().deleteBookmark(user_id, news_id);
    setState(() {
      data.removeWhere((element) => element['news_id'] == news_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Color(0xffF7F7F7),
        appBar: appBar(size, '북마크', context, false, (){}),
        body: Container(
          height: size.height * 0.75,
          margin: EdgeInsets.all(size.width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: FutureBuilder(
            future: getBookmark(widget.user_id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (data.isNotEmpty) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ColorList(
                      title: data[index]['query'],
                      content: data[index]['news_title'],
                      status: true,
                      user_id: widget.user_id,
                      news_id: data[index]['news_id'],
                      deleteBookmark: deleteBookmark,
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
