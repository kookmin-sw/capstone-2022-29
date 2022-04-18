// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/list_color.dart';

List<String> bookmarkKeyword = <String>['북마크 뉴스 키워드 1', '북마크 뉴스 키워드 2', '북마크 뉴스 키워드 3', '북마크 뉴스 키워드 4', '북마크 뉴스 키워드 5', '북마크 뉴스 키워드 6'];
List<String> bookmarkTitle = <String>['북마크 뉴스 제목 1', '북마크 뉴스 제목 2', '북마크 뉴스 제목 3', '북마크 뉴스 제목 4', '북마크 뉴스 제목 5', '북마크 뉴스 제목 6'];
List<bool> isBookmark = <bool>[true,false,true,true,true,true];

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);
  // print(bookmarkTitle);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()=>Future.value(false),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Color(0xffF7F7F7),
        appBar: appBar(size, '북마크', context, false),
        body: Container(
          margin: EdgeInsets.all(size.width*0.05), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30), 
          ),
          child: ListView.builder(
            itemCount: bookmarkKeyword.length,
            itemBuilder: (context, index) {
              return ColorList(
                title: bookmarkKeyword[index],
                content: bookmarkTitle[index],
                status: isBookmark[index],
              );
            },
          ),
        ),
      ),
    );
  }
}