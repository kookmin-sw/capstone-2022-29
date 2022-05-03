// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/list_color.dart';
import 'package:frontend/pages/navigator.dart';

List<String> noticeTitle = <String>[
  'title1',
  'title2',
  'title3',
  'title4',
  'title5'
];
List<String> noticeContent = <String>[
  'content1',
  'content2',
  'content3',
  'content4',
  'content5'
];

class NoticePage extends StatefulWidget {
  NoticePage({Key? key, this.user_id}) : super(key: key);
  String? user_id;

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      appBar: appBar(size, '공지사항', context, false),
      body: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListView.builder(
          itemCount: noticeTitle.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NavigatorPage(
                          index: 7,
                          title: noticeTitle[index],
                          content: noticeContent[index],
                        );
                      },
                    ),
                  );
                },
                child: ColorList(
                  title: noticeTitle[index],
                  content: noticeContent[index],
                ));
          },
        ),
      ),
    );
  }
}
