// ignore_for_file: non_constant_identifier_names, prefer_final_fields, prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/pages/home/home_page.dart';
import 'package:flutter_application/pages/info/info_page.dart';
import 'package:flutter_application/pages/more/more_page.dart';
import 'package:flutter_application/pages/report/report_page.dart';
import 'package:flutter_application/pages/search/search_page.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({Key? key}) : super(key: key);

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  List<Widget> _SelectedTab = <Widget>[
    HomePage(),
    SearchPage(),
    InfoPage(),
    ReportPage(),
    MorePage(),
  ];

  int selectedIndex = 0;

  Color? changeDotIndicatorColor() {
    if (selectedIndex == 0 || selectedIndex == 1 || selectedIndex == 4)
      return Colors.white;
    else
      return Color(0xff5964E1);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black, // Color for Android
        statusBarBrightness: Brightness.light, // for IOS.
      ),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: _SelectedTab.elementAt(selectedIndex),
      bottomNavigationBar: DotNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: Colors.transparent,
        enablePaddingAnimation: false,
        enableFloatingNavBar: false,
        margin: EdgeInsets.only(
            left: size.width * 0.1,
            right: size.width * 0.1,
            bottom: size.height * 0.02),
        dotIndicatorColor: changeDotIndicatorColor(),
        unselectedItemColor: Colors.grey[300],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          DotNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            selectedColor: Color(0xffffffff),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            selectedColor: Color(0xffffffff),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.info_outlined),
            selectedColor: Color(0xff5964E1),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            selectedColor: Color(0xff5964E1),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.notes_outlined),
            selectedColor: Color(0xffffffff),
          ),
        ],
      ),
    );
  }
}
