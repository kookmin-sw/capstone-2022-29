// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';

class MyKeywordPage extends StatefulWidget {
  const MyKeywordPage({Key? key}) : super(key: key);

  @override
  State<MyKeywordPage> createState() => _MyKeywordPageState();
}
List<String> userKeyword = <String>['코로나'];

class _MyKeywordPageState extends State<MyKeywordPage> {
  String _selectedValuesJson = 'Nothing to show';
  late List<Keyword> _selectedLanguages;

  @override
  void initState() {
    _selectedLanguages = [];
    super.initState();
  }

  @override
  void dispose() {
    _selectedLanguages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: appBar(size, '나의 키워드', context, false),
        body: Column(
          children: <Widget>[
          Container(
            // color: Colors.white,
            margin: EdgeInsets.all(size.width * 0.05),
            child: FlutterTagging<Keyword>(
              initialItems: _selectedLanguages,
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: size.width*0.05, bottom: size.height*0.01, top: size.height*0.01, right:  size.width*0.05),
                  // filled: true,
                  fillColor: Colors.white,
                  hintText: '키워드를 입력해주세요',
                  // labelText: 'Select Tags',
                ),
              ),
              findSuggestions: getLanguages,
              additionCallback: (value) {
                return Keyword(name: value);
              },
              onAdded: (keyword) {
                return Keyword(name: keyword.name);
              },
              configureSuggestion: (lang) {
                return SuggestionConfiguration(
                  title: Text(lang.name),
                  // subtitle: Text(lang.position.toString()),
                  additionWidget: Chip(
                    avatar: Icon(
                      Icons.add_circle,
                      color: Color.fromARGB(255, 94, 94, 94),
                    ),
                    label: Text('추가'),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
                    backgroundColor: Color(0xffE7F3FF),
                  ),
                );
              },
              configureChip: (lang) {
                return ChipConfiguration(
                  label: Text(lang.name),
                  backgroundColor: Color(0xffE7F3FF),
                  labelStyle: TextStyle(color: Colors.black),
                  deleteIconColor: Color.fromARGB(255, 94, 94, 94),
                );
              },
              onChanged: () {
                setState(() {
                  _selectedValuesJson = _selectedLanguages
                      .map<String>((lang) => '\n${lang.toJson()}')
                      .toList()
                      .toString();
                  _selectedValuesJson =
                      _selectedValuesJson.replaceFirst('}]', '}\n]');
                });
              },
            ),
          ),
        ],
      ),
      )
    );
  }
}

/// Mocks fetching Keyword from network API with delay of 500ms.
Future<List<Keyword>> getLanguages(String query) async {
  await Future.delayed(Duration(milliseconds: 300), null);
  return <Keyword>[
    Keyword(name: '코로나19'),
    Keyword(name: '메타버스'),
    Keyword(name: '국민대학교'),
  ]
      .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

class Keyword extends Taggable {
  final String name;

  Keyword({
    required this.name,
  });

  @override
  List<Object> get props => [name];
  String toJson() => '''  {
    "name": $name,
  }''';
}