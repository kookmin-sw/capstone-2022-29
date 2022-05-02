// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/components/slide_news/card_news.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:frontend/api/api_service.dart';

Widget slide(BuildContext context, double width, double height, String query) {
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

  List<Widget> getCardNews(double width, double height) {
    for (var i = 0; i < data.length; i++) {
      list.add(
        cardNews(
          width,
          height,
          data[i]['journal'],
          data[i]['title'],
        ),
      );
    }
    return list;
  }

  return Center(
    child: Container(
      height: height * 0.23,
      width: width * 0.9,
      margin: EdgeInsets.only(
        top: height * 0.01,
        bottom: height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: FutureBuilder(
        future: getNews(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (data.length != 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: width * 0.05,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.005,
                              horizontal: width * 0.03,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Color(0xff000000),
                                width: width * 0.0025,
                              ),
                            ),
                            child: Text(
                              "$query",
                              style: TextStyle(
                                fontSize: width * 0.035,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: width * 0.015,
                            ),
                            child: Text(
                              "뉴스",
                              style: TextStyle(
                                fontSize: width * 0.05,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: height * 0.033,
                        margin: EdgeInsets.only(
                          right: width * 0.05,
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NavigatorPage(
                                  index: 3,
                                  query: query,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "바로가기",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: width * 0.035,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            side: BorderSide(
                              width: width * 0.0025,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.15,
                  width: width,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getCardNews(width, height),
                  ),
                ),
              ],
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
