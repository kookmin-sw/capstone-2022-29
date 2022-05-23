// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/components/button2.dart';
import 'package:frontend/models/QA_model.dart';
import 'dart:developer';

class QnAPage extends StatefulWidget {
  QnAPage({Key? key, this.user_id, this.nickname}) : super(key: key);
  String? user_id;
  String? nickname;

  @override
  State<QnAPage> createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void onCanclePressed() {
    print('cancle');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void onConfirmDialog() {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
                content: SizedBox(
                    height: size.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Q&A가 정상적으로 등록되었으며,\n일주일 이내로 처리됩니다.'),
                        button(size, "닫기", () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                      ],
                    )));
          });
    }

    void onClickPressed() async {
      await ApiService()
          .postQA(QA(
            title: titleController.text,
            content: contentController.text,
            receiver: emailController.text,
          ))
          .then((value) => {onConfirmDialog()});
    }

    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        resizeToAvoidBottomInset: false,
        appBar: appBar(size, 'Q&A', context, true, false, () {}),
        body: Column(
          children: <Widget>[
            Center(
              child: Container(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: titleController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Q&A 제목을 입력해주세요',
                  ),
                  cursorColor: Colors.black,
                ),
                width: size.width * 0.8,
                height: size.height * 0.05,
                margin: EdgeInsets.only(top: size.height * 0.02),
                padding: EdgeInsets.only(
                    left: size.width * 0.05, right: size.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: 20,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Q&A 내용을 입력해주세요',
                ),
                cursorColor: Colors.black,
              ),
              width: size.width * 0.8,
              margin: EdgeInsets.only(top: size.height * 0.02),
              padding: EdgeInsets.only(
                  left: size.width * 0.05,
                  top: size.height * 0.01,
                  right: size.width * 0.05,
                  bottom: size.height * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Center(
              child: Container(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '답변을 받으실 이메일을 입력해주세요.',
                  ),
                  cursorColor: Colors.black,
                ),
                width: size.width * 0.8,
                height: size.height * 0.05,
                margin: EdgeInsets.only(top: size.height * 0.02),
                padding: EdgeInsets.only(
                    left: size.width * 0.05, right: size.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            buttonTwo(size, '취소', '저장', onCanclePressed, onClickPressed),
          ],
        ));
  }
}
