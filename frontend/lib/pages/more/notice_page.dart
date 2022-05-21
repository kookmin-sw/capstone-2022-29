// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/list_color.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:frontend/api/api_service.dart';

class NoticePage extends StatefulWidget {
  NoticePage({Key? key, this.user_id, this.nickname}) : super(key: key);
  String? user_id;
  String? nickname;

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Map> data = [];
  bool isNotice = true;

  Future<void> getNotice() async {
    List<dynamic> notice = await ApiService().getNotice();
    if (notice.isNotEmpty) {
      for (var i = 0; i < notice.length; i++) {
        isNotice = true;
        data.add(
            {"title": notice[i]['title'], "content": notice[i]['content']});
      }
    } else {
      isNotice = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      appBar: appBar(size, '공지사항', context, true, false, () {}),
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
            if (isNotice) {
              if (data.isNotEmpty) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return NavigatorPage(
                                  index: 7,
                                  title: data[index]['title'],
                                  content: data[index]['content'],
                                  user_id: widget.user_id,
                                  nickname: widget.nickname,
                                );
                              },
                            ),
                          );
                        },
                      child: Container(
                        child: Column(children: [
                          Container(
                            child: Text(data[index]['title'],maxLines: 1, overflow: TextOverflow.ellipsis),
                            width: size.width,
                            height: size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(198, 228, 255, 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(40.0),
                                  topRight: const Radius.circular(40.0),
                                )),
                            padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height*0.01, size.width * 0.05, 0),
                          ),
                          Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[index]['content'], maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                              width: size.width,
                              height: size.height * 0.05,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(247, 247, 247, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: const Radius.circular(30),
                                    bottomRight: const Radius.circular(30),
                                  )),
                              padding: EdgeInsets.fromLTRB(
                                  size.width * 0.05, 0, size.width * 0.05, 0),
                            ),
                        ]),
                        margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02,
                            size.width * 0.05, size.height * 0.01),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('공지사항이 없습니다ㅜㅅㅜ'),
                );
              }
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
