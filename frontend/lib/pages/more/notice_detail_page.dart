// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';

class NoticeDetailPage extends StatefulWidget {
  NoticeDetailPage(
      {Key? key, this.title, this.content, this.user_id, this.nickname})
      : super(key: key);
  String? title;
  String? content;
  String? user_id;
  String? nickname;

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(231, 243, 255, 1),
        appBar: appBar(size, '', context, true, false, () {}),
        body: Container(
          child: Column(children: [
            Container(
              width: size.width,
              height: size.height * 0.05,
              child: Center(child: Text(widget.title ?? '')),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Container(
                width: size.width,
                height: size.height * 0.6,
                child: SingleChildScrollView(child: Text(widget.content ?? '')),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: EdgeInsets.fromLTRB(0, size.height*0.02, 0, size.height*0.02),
                padding: EdgeInsets.fromLTRB(size.width*0.03, size.height*0.025, size.width*0.03, size.height*0.025))
          ]),
          margin: EdgeInsets.fromLTRB(48, 20, 48, 20),
        ));
  }
}
