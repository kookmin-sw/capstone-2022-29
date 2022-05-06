// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
AppBar appBar(
    Size size, String? title, BuildContext context, bool isBack, Function isShow) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: isBack
        ? Container(
            margin: EdgeInsets.only(left: size.width * 0.05),
            child: IconButton(
              icon: Image.asset('lib/assets/images/backIcon.png',
                  width: size.width * 0.1, height: size.width * 0.1),
              onPressed: () => Navigator.pop(context),
            ),
          )
        : Container(),
    title: title != ' '
        ? Container(
            child: Center(
                child: title != ''
                    ? Text(title ?? '', style: TextStyle(color: Colors.black))
                    : Image.asset('lib/assets/images/logo_mini.png')),
            width: size.width * 0.4,
            height: size.width * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          )
        : null,
    centerTitle: true,
    elevation: 0.0,
    actions: [
      isShow != (){}
          ? Container(
              margin: EdgeInsets.only(right: size.width * 0.05),
              child: IconButton(
                icon: Icon(Icons.share_outlined),
                color: Colors.black,
                onPressed: ()=>{isShow()},
                // () {
                  // Share.share('Hello Welcome to FlutterCampus',
                  //     subject: 'Welcome Message');
                // },
              ),
            )
          : Container(),
    ],
  );
}
