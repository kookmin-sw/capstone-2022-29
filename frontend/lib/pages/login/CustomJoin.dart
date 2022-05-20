import 'package:flutter/material.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/pages/login/login_page.dart';
import 'package:frontend/pages/navigator.dart';

class CustomJoinPage extends StatefulWidget {
  CustomJoinPage({Key? key,
  //  this.user_id, this.nickname, this.password
  }) : super(key: key);
  // String? user_id;
  // String? nickname;
  // String? password;

  @override
  State<CustomJoinPage> createState() => _CustomJoinPageState();
}

class _CustomJoinPageState extends State<CustomJoinPage> {
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
            controller: nicknameController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'nickname을 입력해주세요',
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
          button(size, '회원가입 완료', (){
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigatorPage(
                index: 0,
                // nickname: nicknameController,
                // user_id: idController,
                // method: method,
              ),
            ),
          );
          })
        ],
      )
    );
  }
}