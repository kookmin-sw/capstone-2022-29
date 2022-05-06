// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/list_color.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:frontend/api/api_service.dart';

class NoticePage extends StatefulWidget {
  NoticePage({Key? key, this.user_id}) : super(key: key);
  String? user_id;

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Map> data = [];

  Future<void> getNotice() async {
    List<dynamic> notice = await ApiService().getNotice();
    for (var i = 0; i < notice.length; i++) {
      data.add({"title": notice[i]['title'], "content": notice[i]['content']});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      appBar: appBar(size, '공지사항', context, true, (){}),
      body: Container(
        height: size.height * 0.75,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: FutureBuilder(
          future: getNotice(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (data.isNotEmpty) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NavigatorPage(
                                index: 7,
                                title: data[index]['title'],
                                content: data[index]['content'],
                                user_id: widget.user_id,
                              );
                            },
                          ),
                        );
                      },
                      child: ColorList(
                        title: data[index]['title'],
                        content: data[index]['content'],
                      ));
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
    );
  }
}
