// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/components/slide_news/slide.dart';
import 'package:frontend/pages/navigator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 가로
          mainAxisAlignment: MainAxisAlignment.start, // 세로
          children: [
            logo(size),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NavigatorPage(index: 1);
                    },
                  ),
                );
              },
              child: AbsorbPointer(
                child: searchBar(size),
              ),
            ),
            SizedBox(
              height: size.height * 0.67,
              child: ListView(
                shrinkWrap: true,
                children: [
                  slide(size, '코로나'),
                  slide(size, '우크라이나'),
                  slide(size, '국민대학교'),
                  slide(size, '메타버스'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
