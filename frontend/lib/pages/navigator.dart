// ignore_for_file: prefer_const_constructors, unused_element, unused_local_variable, prefer_const_constructors_in_immutables, prefer_final_fields, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:frontend/pages/bookmark/bookmark_page.dart';
import 'package:frontend/pages/home/home_page.dart';
import 'package:frontend/pages/home/news_page.dart';
import 'package:frontend/pages/search/search_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({Key? key, required this.index, this.query}) : super(key: key);
  int index = 0;
  String? query;

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  List<Widget> _widgetOptions() => <Widget>[
        HomePage(),
        SearchPage(),
        BookmarkPage(),
        NewsPage(query: widget.query),
      ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final List<Widget> widgetOptions = _widgetOptions();
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(widget.index),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: size.width * 0.05,
          right: size.width * 0.05,
        ),
        child: SafeArea(
          child: GNav(
            gap: 10,
            backgroundColor: Color(0xffF7F7F7),
            iconSize: 24,
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.01,
            ),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Color(0xffC6E4FF),
            activeColor: Color(0xff0086FF),
            color: Colors.black,
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: '홈',
              ),
              GButton(
                icon: LineIcons.search,
                text: '검색',
              ),
              GButton(
                icon: LineIcons.bookmark,
                text: '북마크',
              ),
            ],
            selectedIndex: widget.index,
            onTabChange: (idx) {
              setState(() {
                widget.index = idx;
              });
            },
          ),
        ),
      ),
    );
  }
}
