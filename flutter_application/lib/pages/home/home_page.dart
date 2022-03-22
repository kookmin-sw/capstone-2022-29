// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget logo(Size size) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.04),
      width: size.width * 0.4,
      child: Image.asset('lib/assets/logo_mini.png'),
    );
  }

  Widget search(Size size) {
    return Center(
      child: Container(
        height: size.height * 0.15,
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
            Container(
              margin: EdgeInsets.only(left: size.width * 0.05),
              child: Text(
                "스팸 번호 검색",
                style: TextStyle(fontSize: size.width * 0.05),
              ),
            ),
            Center(
              child: SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.8,
                child: OutlineSearchBar(
                  borderColor: Color(0xff5964E1),
                  cursorColor: Color(0xff5964E1),
                  searchButtonIconColor: Color(0xff5964E1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget information(Size size) {
    return Center(
      child: Container(
        height: size.height * 0.15,
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
                Container(
                  margin: EdgeInsets.only(left: size.width * 0.05),
                  child: Text(
                    "스미싱 정보",
                    style: TextStyle(fontSize: size.width * 0.05),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: size.width * 0.05),
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "바로가기",
                      style: TextStyle(
                        color: Color(0xff5964E1),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      side: BorderSide(
                        width: size.width * 0.003,
                        color: Color(0xff5964E1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xff5964E1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 가로
          mainAxisAlignment: MainAxisAlignment.center, // 세로
          children: [
            logo(size),
            search(size),
            information(size),
          ],
        ),
      ),
    );
  }
}
