// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/detail_title.dart';
import 'package:frontend/components/detail_content.dart';

class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(231, 243, 255, 1),
      appBar: appBar(context, ''),
      body: Container(
        child: Column(
          children: [
            detailTitle(context, '공지사항 제목'),
            detailContent(context, '공지사항 내용입니다.'),
          ]
        ),
        margin: EdgeInsets.fromLTRB(48, 20, 48, 20),
      )
    );
  }
}
