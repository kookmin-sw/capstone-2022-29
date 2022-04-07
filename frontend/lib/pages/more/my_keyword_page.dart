// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';

List<String> noticeTitle = <String>['title1', 'title2', 'title3', 'title4', 'title5'];
List<String> noticeContent = <String>['content1', 'content2', 'content3', 'content4', 'content5'];

class MyKeywordPage extends StatelessWidget {
  const MyKeywordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      appBar: appBar(size, '나의 키워드'),
      body: Container(
        
      ),
    );
  }
}
