// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:frontend/models/keyword_model.dart';

class MyKeywordPage extends StatefulWidget {
  MyKeywordPage({Key? key, this.user_id}) : super(key: key);
  String? user_id;

  @override
  State<MyKeywordPage> createState() => _MyKeywordPageState();
}
// List<String> userKeyword = <String>['코로나'];

class _MyKeywordPageState extends State<MyKeywordPage> {
  String _selectedValuesJson = 'Nothing to show';
  late List<Tag> _selectedLanguages;
  List<dynamic> keywordList = [];

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

  Future<void> getKeyword(dynamic user_id) async {
    keywordList.clear();
    _selectedLanguages.clear();
    keywordList = await ApiService().getKeyword(user_id);
    for (var i = 0; i < keywordList.length; i++) {
      for (var j = 0; j < keywordList[i]['keywords'].length; j++) {
        _selectedLanguages
            .add(Tag(name: keywordList[i]['keywords'][j]['keyword']));
      }
    }
  }

  Future<void> postKeyword(String user_id, String keyword) async {
    if (_selectedLanguages.isEmpty) {
      await ApiService().postKeyword(
        Keyword(
          user_id: user_id,
          keywords: Keywords(keyword: keyword),
        ),
      );
    } else {
      await ApiService().updateKeyword(
        user_id,
        Keyword(
          user_id: user_id,
          keywords: Keywords(keyword: keyword),
        ),
      );
    }
  }

  Future<void> deleteKeyword(String user_id, String keyword) async {
    dynamic response = await ApiService()
        .deleteKeyword(user_id, keyword, Keyword.fromJson(keywordList[0]));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: appBar(size, '나의 키워드', context, true, false),
        body: FutureBuilder(
          future: getKeyword(widget.user_id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (_selectedLanguages.isNotEmpty) {
              return Column(
                children: <Widget>[
                  Container(
                    // color: Colors.white,
                    margin: EdgeInsets.all(size.width * 0.05),
                    child: FlutterTagging<Tag>(
                      initialItems: _selectedLanguages,
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: size.width * 0.05,
                              bottom: size.height * 0.01,
                              top: size.height * 0.01,
                              right: size.width * 0.05),
                          // filled: true,
                          fillColor: Colors.white,
                          hintText: '키워드를 입력해주세요',
                          // labelText: 'Select Tags',
                        ),
                      ),
                      findSuggestions: getLanguages,
                      additionCallback: (value) {
                        return Tag(name: value);
                      },
                      onAdded: (keyword) {
                        postKeyword(
                            widget.user_id!, keyword.name); // update keyword
                        return Tag(name: keyword.name);
                      },
                      configureSuggestion: (lang) {
                        return SuggestionConfiguration(
                          title: Text(lang.name),
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
                        // delete
                        // deleteKeyword(widget.user_id!, lang.name);
                        return ChipConfiguration(
                          label: Text(lang.name),
                          backgroundColor: Color(0xffE7F3FF),
                          labelStyle: TextStyle(color: Colors.black),
                          deleteIconColor: Color.fromARGB(255, 94, 94, 94),
                          deleteIcon: GestureDetector(
                            child: Icon(Icons.cancel),
                            onTap: () {
                              deleteKeyword(widget.user_id!, lang.name);
                            },
                          ),
                        );
                      },
                      // onChanged: () {
                      //   setState(() {
                      //     _selectedValuesJson = _selectedLanguages
                      //         .map<String>((lang) => '\n${lang.toJson()}')
                      //         .toList()
                      //         .toString();
                      //     _selectedValuesJson =
                      //         _selectedValuesJson.replaceFirst('}]', '}\n]');
                      //   });
                      // },
                      onChanged: () {
                        print(_selectedLanguages);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

/// Mocks fetching Keyword from network API with delay of 500ms.
Future<List<Tag>> getLanguages(String query) async {
  // await Future.delayed(Duration(milliseconds: 300), null);
  // return <Tag>[
  //   Tag(name: ''),
  // ]
  //     .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
  //     .toList();
  return [];
}

class Tag extends Taggable {
  final String name;

  Tag({
    required this.name,
  });

  @override
  List<Object> get props => [name];
  String toJson() => '''  {
    "name": $name,
  }''';
}
