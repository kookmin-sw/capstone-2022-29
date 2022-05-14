// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend/pages/navigator.dart';

class ColorList extends StatefulWidget {
  ColorList(
      {Key? key,
      required this.title,
      required this.content,
      this.status,
      this.user_id,
      this.nickname,
      this.news_id,
      this.deleteBookmark})
      : super(key: key);
  String title;
  String content;
  bool? status;
  String? user_id;
  String? nickname;
  String? news_id;
  final Function? deleteBookmark;

  @override
  State<ColorList> createState() => _ColorListState();
}

class _ColorListState extends State<ColorList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(widget.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
              widget.status != null
                  ? InkWell(
                      child: Container(
                        child: Image.asset(
                          widget.status!
                              ? 'lib/assets/images/bookmark_true.png'
                              : 'lib/assets/images/bookmark_false.png',
                          width: size.width * 0.05,
                        ),
                        margin: EdgeInsets.only(right: size.width * 0.02),
                      ),
                      onTap: () {
                        setState(() {
                          widget.status = !widget.status!;
                          if (widget.status == false) {
                            widget.deleteBookmark!(
                                widget.user_id, widget.news_id);
                          }
                        });
                      },
                    )
                  : Container()
            ],
          ),
          width: size.width,
          height: size.height * 0.04,
          decoration: BoxDecoration(
              color: Color.fromRGBO(198, 228, 255, 1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(40.0),
                topRight: const Radius.circular(40.0),
              )),
          padding:
              EdgeInsets.fromLTRB(size.width * 0.05, 0, size.width * 0.05, 0),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NavigatorPage(
                    index: 5,
                    query: widget.title,
                    user_id: widget.user_id,
                    nickname: widget.nickname,
                    news_id: widget.news_id,
                    // topicNum: 0,
                    // topicStepNum: 0,
                  );
                },
              ),
            );
          },
          child: Container(
            child: Text(widget.content,
                maxLines: 2, overflow: TextOverflow.ellipsis),
            width: size.width,
            height: 60,
            decoration: BoxDecoration(
                color: Color.fromRGBO(247, 247, 247, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(30),
                  bottomRight: const Radius.circular(30),
                )),
            padding: EdgeInsets.fromLTRB(
                size.width * 0.05, size.height * 0.02, size.width * 0.05, 0),
          ),
        ),
      ]),
      margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02,
          size.width * 0.05, size.height * 0.01),
      decoration: BoxDecoration(),
    );
  }
}
