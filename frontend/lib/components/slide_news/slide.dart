// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:frontend/components/slide_news/card_news.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:frontend/api/api_service.dart';

Widget slide(bool isCollapsed, BuildContext context, Size size, String query,
    String user_id) {
  List<Map> data = [];
  List<Widget> list = [];

  Future<void> getNews(dynamic query) async {
    data.clear();
    List<dynamic> news = await ApiService().getNews(query);
    // print("page: ${news.length}");
    for (var i = 0; i < news.length; i++) {
      data.add({"journal": news[i]["journal"], "title": news[i]["title"]});
    }
  }

  List<Widget> getCardNews(Size size) {
    for (var i = 0; i < data.length; i++) {
      list.add(
        cardNews(
          size,
          data[i]['journal'],
          data[i]['title'],
        ),
      );
    }
    return list;
  }

  return Center(
    child: Container(
      height: size.height * 0.23,
      width: size.width * 0.9,
      margin: EdgeInsets.only(
        top: size.height * 0.01,
        bottom: size.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: FutureBuilder(
        future: getNews(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (data.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: size.width * 0.05,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.005,
                            horizontal: size.width * 0.03,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Color(0xff000000),
                              width: size.width * 0.0025,
                            ),
                          ),
                          child: Text(
                            "$query",
                            style: TextStyle(
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: size.width * 0.015,
                          ),
                          child: Text(
                            "뉴스",
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(width: size.width*0.35),
                    if (isCollapsed)
                      Container(
                        height: size.height * 0.033,
                        margin: EdgeInsets.only(
                          right: size.width * 0.05,
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NavigatorPage(
                                  index: 3,
                                  query: query,
                                  user_id: user_id,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "바로가기",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: size.width * 0.035,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            side: BorderSide(
                              width: size.width * 0.0025,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Container(
                  height: size.height * 0.15,
                  width: size.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getCardNews(size),
                  ),
                ),
              ],
              // ),
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
