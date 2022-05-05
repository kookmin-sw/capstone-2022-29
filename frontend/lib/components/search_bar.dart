// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/pages/search/search_provider.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:provider/provider.dart';

class searchBar extends StatelessWidget {
  searchBar({Key? key, required this.size, required this.color, required this.value}) : super(key: key);
  Size size;
  bool color;
  String value;

  @override
  Widget build(BuildContext context) {
    SearchProvider _searchProvider = Provider.of<SearchProvider>(context);

    return Center(
      child: Container(
        height: size.height * 0.065,
        width: size.width * 0.9,
        margin: EdgeInsets.only(
          top: size.height * 0.01,
          bottom: size.height * 0.01,
        ),
        child: OutlineSearchBar(
          hideSearchButton: color? true:false,
          borderRadius: BorderRadius.circular(30),
          backgroundColor: Colors.white,
          borderColor: color? Colors.black:Colors.transparent,
          cursorColor: Colors.black,
          searchButtonIconColor: Colors.black,
          hintText: color? "주제 검색":"",
          initText: value != ""? value:"",
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
          ),
          onKeywordChanged: (String value) {
            context.read<SearchProvider>().onChange(value);
          },
          onSearchButtonPressed: (String value) {
            context.read<SearchProvider>().onChange(value);
          },
        ),
      ),
    );
  }
}
