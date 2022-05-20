// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/list_color.dart';
import 'package:frontend/api/api_service.dart';

class BookmarkPage extends StatefulWidget {
  BookmarkPage({Key? key, this.user_id, this.nickname}) : super(key: key);
  String? user_id;
  String? nickname;

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map> data = [];
  bool isBookmark = true;

  Future<void> getBookmark(dynamic user_id) async {
    data.clear();
    List<dynamic> bookmark = await ApiService().getBookmark(user_id);
    if (bookmark.isNotEmpty) {
      for (var i = 0; i < bookmark.length; i++) {
        if (bookmark[i]['bookmark'].length == 0) {
          isBookmark = false;
        } else {
          isBookmark = true;
          for (var j = 0; j < bookmark[i]['bookmark'].length; j++) {
            data.add({
              'news_id': bookmark[i]['bookmark'][j]['news_id'],
              'news_title': bookmark[i]['bookmark'][j]['news_id'],
              'query': bookmark[i]['bookmark'][j]['query']
            });
          }
        }
      }
      for (var i = 0; i < data.length; i++) {
        await getNewsTitle(data[i]['news_title'], i);
      }
    } else {
      isBookmark = false;
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
      // print(data.length);
      if (data.isEmpty) {
        isBookmark = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Color(0xffF7F7F7),
        appBar: appBar(size, '북마크', context, false, false, () {}),
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
              if (isBookmark) {
                if (data.isNotEmpty) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ColorList(
                        title: data[index]['query'],
                        content: data[index]['news_title'],
                        status: true,
                        user_id: widget.user_id,
                        nickname: widget.nickname,
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
              } else {
                return Center(
                  child: Text(
                    "원하는 뉴스를 북마크 해보세요!",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
