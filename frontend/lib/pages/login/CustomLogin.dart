import 'package:flutter/material.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/pages/login/login_page.dart';

class CustomLoginPage extends StatefulWidget {
  CustomLoginPage({Key? key, 
  // this.user_id, this.nickname, this.password
  }) : super(key: key);
  // String? user_id;
  // String? nickname;
  // String? password;

  @override
  State<CustomLoginPage> createState() => _CustomLoginPageState();
}

class _CustomLoginPageState extends State<CustomLoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          TextField(
            textAlign: TextAlign.center,
            controller: idController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'ID를 입력해주세요',
            ),
            cursorColor: Colors.black,
          ),
          TextField(
            textAlign: TextAlign.center,
            controller: passwordController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'password를 입력해주세요',
            ),
            cursorColor: Colors.black,
          ),
          button(size, '로그인 완료', (){
              
          })
        ],
      )
    );
  }
}