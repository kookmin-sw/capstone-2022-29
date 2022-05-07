// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/button2.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class QnAPage extends StatefulWidget {
  QnAPage({Key? key, this.user_id}) : super(key: key);
  String? user_id;

  @override
  State<QnAPage> createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void onClickPressed() async{
    print('title: ' + titleController.text);
    print('content: ' + contentController.text);
    print('email: ' + emailController.text);

    final Email email = Email(
      body: contentController.text + '\n\n' + emailController.text,
      subject: titleController.text,
      recipients: ['ch2w2006@kookmin.ac.kr'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }

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
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        appBar: appBar(size, 'Q&A', context, true, false, (){}),
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
