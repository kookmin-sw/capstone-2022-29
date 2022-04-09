// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:frontend/components/slide_news/card_news.dart';
import 'package:frontend/pages/navigator.dart';

Widget slide(BuildContext context, Size size, String query) {
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
      child: Column(
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
              children: <Widget>[
                cardNews(size, '조선일보', '$query기사1'),
                cardNews(size, '조선일보', '$query기사2'),
                cardNews(size, '조선일보', '$query기사3'),
                cardNews(size, '조선일보', '$query기사4'),
                cardNews(size, '조선일보', '$query기사5'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
