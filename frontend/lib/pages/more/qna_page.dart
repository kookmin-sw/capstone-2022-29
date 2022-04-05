// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
// import 'package:frontend/components/detail_title.dart';
// import 'package:frontend/components/detail_content.dart';

class QnAPage extends StatelessWidget {
  const QnAPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      appBar: appBar(context, 'Q&A'),
      body: Column(
        children: [
        //   Container(
        //     width: size.width,    
        //     height: 40,
        //     child: TextFormField(
        //       decoration: InputDecoration(
        //         labelText: 'Q&A 제목을 입력해주세요',
        //         fillColor: Colors.white,
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(30),
        //           borderSide: BorderSide(),
        //         ),
        //       ),
        //     ),
        //     margin: EdgeInsets.fromLTRB(48, 20, 48, 20),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(30),
        //     ),
        //  ),
        //  Container(
        //     width: size.width,    
        //     height: 340,
        //     child: TextFormField(
        //       minLines: 1,
        //       maxLines: 5,  // allow user to enter 5 line in textfield
        //       keyboardType: TextInputType.multiline,  // user keyboard will have a button to move cursor to next line
        //       // controller: _Textcontroller,
            
        //       decoration: InputDecoration(
        //         labelText: 'Q&A 내용을 입력해주세요',
        //         fillColor: Colors.white,
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(30),
        //           borderSide: BorderSide(),
        //         ),
        //       ),
        //     ),
        //     margin: EdgeInsets.fromLTRB(48, 0, 48, 0),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(30),
        //     ),
        //   ),
        //   Container(
        //     width: size.width,    
        //     height: 40,
        //     child: TextFormField(
        //       decoration: InputDecoration(
        //         labelText: '답변을 받으실 연락처/이메일을 입력해주세요',
        //         fillColor: Colors.white,
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(30),
        //           borderSide: BorderSide(),
        //         ),
        //       ),
        //     ),
        //     margin: EdgeInsets.fromLTRB(48, 20, 48, 20),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(30),
        //     ),
        //  ),
        ]
      )
    );
  }
}
