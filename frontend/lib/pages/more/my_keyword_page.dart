// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:textfield_tags/textfield_tags.dart';

class MyKeywordPage extends StatefulWidget {
  const MyKeywordPage({Key? key}) : super(key: key);

  @override
  State<MyKeywordPage> createState() => _MyKeywordPageState();
}
List<String> userKeyword = <String>['코로나'];

class _MyKeywordPageState extends State<MyKeywordPage> {
  double _distanceToField = 0.0;
  TextfieldTagsController _controller = TextfieldTagsController();
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  static const List<String> _pickLanguage = <String>[
    'c',
    'c++',
    'java',
    'python',
    'javascript',
    'php',
    'sql',
    'yaml',
    'gradle',
    'xml',
    'html',
    'flutter',
    'css',
    'dockerfile'
  ];
  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    return MaterialApp(
      title: "wellcome",
      home: Scaffold(
        appBar: appBar(size, '나의 키워드', context, false),
        body: Column(
          children: [
            Autocomplete<String>(
              optionsViewBuilder: (context, onSelected, options) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Material(
                      elevation: 4.0,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final dynamic option = options.elementAt(index);
                            return TextButton(
                              onPressed: () {
                                onSelected(option);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text(
                                    '$option',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _pickLanguage.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selectedTag) {
                _controller.addTag = selectedTag;
              },
              fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                return TextFieldTags(
                  textEditingController: ttec,
                  focusNode: tfn,
                  textfieldTagsController: _controller,
                  initialTags: userKeyword,
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    print('[$tag]');
                    if (tag.trim() == ' ') {
                      return 'No, please just no';
                    }
                    if (tag == 'php'){
                      return 'No, please just no';
                    }
                    // } else if (_controller.getTags.contains(tag)) {
                    //   return 'you already entered that';
                    // }
                    return null;
                  },
                  inputfieldBuilder:
                      (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      userKeyword = tags;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          controller: tec,
                          focusNode: fn,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 74, 137, 92),
                                  width: 3.0),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 74, 137, 92),
                                  width: 3.0),
                            ),
                            helperText: 'Enter language...',
                            helperStyle: const TextStyle(
                              color: Color.fromARGB(255, 74, 137, 92),
                            ),
                            hintText: _controller.hasTags ? '' : "Enter tag...",
                            errorText: error,
                            prefixIconConstraints: BoxConstraints(maxWidth: _distanceToField * 0.74),
                            prefixIcon: tags.isNotEmpty
                                ? SingleChildScrollView(
                                    controller: sc,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: tags.map((String tag) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          color:
                                              Color.fromRGBO(231, 243, 255, 1)
                                        ),
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                tag,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              onTap: () {
                                                print("$tag selected");
                                              },
                                            ),
                                            const SizedBox(width: 4.0),
                                            InkWell(
                                              child: Image.asset('lib/assets/images/keyword_del.png', width: size.width*0.05),
                                              onTap: () {
                                                onTagDelete(tag);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList()),
                                  )
                                : null,
                          ),
                          onChanged: onChanged,
                          onSubmitted: (String tag) {
                            print(userKeyword);
                            setState(() {
                              userKeyword.add(tag);
                            });
                            print(userKeyword);
                          },
                        ),
                      );
                    });
                  },
                );
              },
            ),
            // Row(
            //   children: userKeyword.map((String tag) {
            //   return Container(
            //     decoration: const BoxDecoration(
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(20.0),
            //       ),
            //       color:
            //           Color.fromRGBO(231, 243, 255, 1)
            //     ),
            //     margin:
            //         const EdgeInsets.only(right: 10.0),
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 10.0, vertical: 4.0),
            //     child: Row(
            //       mainAxisAlignment:
            //           MainAxisAlignment.spaceBetween,
            //       children: [
            //         InkWell(
            //           child: Text(
            //             tag,
            //             style: const TextStyle(
            //                 color: Colors.black),
            //           ),
            //           onTap: () {
            //             print("$tag selected");
            //           },
            //         ),
            //         const SizedBox(width: 4.0),
            //         InkWell(
            //           child: Image.asset('lib/assets/images/keyword_del.png', width: size.width*0.05),
            //           onTap: () {
            //             // onTagDelete(tag);
            //             print('$tag delete');
            //           },
            //         )
            //       ],
            //     ),
            //   );
            // }).toList()),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 74, 137, 92),
                ),
              ),
              onPressed: () {
                _controller.clearTags();
              },
              child: const Text('CLEAR TAGS'),
            ),

          ],
        ),
      ),
    );
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_syntax_view/flutter_syntax_view.dart';
// import 'package:flutter_tagging/flutter_tagging.dart';



// class MyKeywordPage extends StatefulWidget {
//   const MyKeywordPage({Key? key}) : super(key: key);

//   @override
//   State<MyKeywordPage> createState() => _MyKeywordPageState();
// }

// class _MyKeywordPageState extends State<MyKeywordPage> {
//   String _selectedValuesJson = 'Nothing to show';
//   late final List<Language> _selectedLanguages;

//   @override
//   void initState() {
//     super.initState();
//     _selectedLanguages = [];
//   }

//   @override
//   void dispose() {
//     _selectedLanguages.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Tagging Demo'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: FlutterTagging<Language>(
//               initialItems: _selectedLanguages,
//               textFieldConfiguration: TextFieldConfiguration(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   filled: true,
//                   fillColor: Colors.green.withAlpha(30),
//                   hintText: 'Search Tags',
//                   labelText: 'Select Tags',
//                 ),
//               ),
//               findSuggestions: LanguageService.getLanguages,
//               additionCallback: (value) {
//                 return Language(
//                   name: value,
//                   position: 0,
//                 );
//               },
//               onAdded: (language) {
//                 // api calls here, triggered when add to tag button is pressed
//                 return language;
//               },
//               configureSuggestion: (lang) {
//                 return SuggestionConfiguration(
//                   title: Text(lang.name),
//                   subtitle: Text(lang.position.toString()),
//                   additionWidget: Chip(
//                     avatar: Icon(
//                       Icons.add_circle,
//                       color: Colors.white,
//                     ),
//                     label: Text('Add New Tag'),
//                     labelStyle: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.0,
//                       fontWeight: FontWeight.w300,
//                     ),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//               },
//               configureChip: (lang) {
//                 return ChipConfiguration(
//                   label: Text(lang.name),
//                   backgroundColor: Colors.green,
//                   labelStyle: TextStyle(color: Colors.white),
//                   deleteIconColor: Colors.white,
//                 );
//               },
//               onChanged: () {
//                 setState(() {
//                   _selectedValuesJson = _selectedLanguages
//                       .map<String>((lang) => '\n${lang.toJson()}')
//                       .toList()
//                       .toString();
//                   _selectedValuesJson =
//                       _selectedValuesJson.replaceFirst('}]', '}\n]');
//                 });
//               },
//             ),
//           ),
//           SizedBox(
//             height: 20.0,
//           ),
//           Expanded(
//             child: SyntaxView(
//               code: _selectedValuesJson,
//               syntax: Syntax.JAVASCRIPT,
//               withLinesCount: false,
//               syntaxTheme: SyntaxTheme.standard(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// LanguageService
// class LanguageService {
//   /// Mocks fetching language from network API with delay of 500ms.
//   static Future<List<Language>> getLanguages(String query) async {
//     await Future.delayed(Duration(milliseconds: 500), null);
//     return <Language>[
//       Language(name: 'JavaScript', position: 1),
//       Language(name: 'Python', position: 2),
//       Language(name: 'Java', position: 3),
//       Language(name: 'PHP', position: 4),
//       Language(name: 'C#', position: 5),
//       Language(name: 'C++', position: 6),
//     ]
//         .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
// }

// /// Language Class
// class Language extends Taggable {
//   ///
//   final String name;

//   ///
//   final int position;

//   /// Creates Language
//   Language({
//     required this.name,
//     required this.position,
//   });

//   @override
//   List<Object> get props => [name];

//   /// Converts the class to json string.
//   String toJson() => '''  {
//     "name": $name,\n
//     "position": $position\n
//   }''';
// }