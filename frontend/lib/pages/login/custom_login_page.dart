// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/pages/login/validator.dart';
import 'package:frontend/components/button2.dart';

class CustomLoginPage extends StatefulWidget {
  CustomLoginPage({Key? key}) : super(key: key);

  @override
  State<CustomLoginPage> createState() => _CustomLoginPageState();
}

class _CustomLoginPageState extends State<CustomLoginPage> {
  FocusNode _nicknameFocus = FocusNode();
  FocusNode _idFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  String nickname = '';
  String id = '';
  String password = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCanclePressed() {
    print('cancle');
    Navigator.pop(context);
  }

  void onClickPressed() async {
    if (formKey.currentState!.validate()) {
      print('nickname: $nickname, id: $id, password: $password');
      var user = await ApiService().getUserInfo(nickname);
      if (user != null && user['id'] == id && user['password'] == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigatorPage(
              index: 0,
              nickname: nickname,
              user_id: user['_id'],
              method: 'custom',
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("로그인 실패"),
              // content: Text("로그인 실패"),
              actions: <Widget>[
                TextButton(
                  child: Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      formKey.currentState!.validate();
    }
  }

  Widget _showNicknameInput(Size size) {
    return SizedBox(
      width: size.width * 0.75,
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: _nicknameFocus,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: size.height * 0.01),
          hintText: '닉네임',
          helperText: '3자 이상 8자 이내의 한글, 영어, 숫자로 입력하세요',
        ),
        validator: (value) =>
            CheckValidate().validateNickname(_nicknameFocus, value!),
        onChanged: (value) {
          nickname = value;
        },
      ),
    );
  }

  Widget _showIdInput(Size size) {
    return SizedBox(
      width: size.width * 0.75,
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: _idFocus,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: size.height * 0.01),
          hintText: '아이디',
          helperText: '3자 이상 8자 이내의 한글, 영어, 숫자로 입력하세요',
        ),
        validator: (value) => CheckValidate().validateId(_idFocus, value!),
        onChanged: (value) {
          id = value;
        },
      ),
    );
  }

  Widget _showPasswordInput(Size size) {
    return SizedBox(
      width: size.width * 0.75,
      child: TextFormField(
        focusNode: _passwordFocus,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: size.height * 0.01),
          hintText: '비밀번호',
          helperText: '영어, 숫자 포함 8자 이상 15자 이내로 입력하세요',
        ),
        validator: (value) =>
            CheckValidate().validatePassword(_passwordFocus, value!),
        onChanged: (value) {
          password = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _showNicknameInput(size),
              _showIdInput(size),
              _showPasswordInput(size),
              SizedBox(
                height: size.height * 0.03,
              ),
              buttonTwo(size, '취소', '확인', onCanclePressed, onClickPressed),
            ],
          ),
        ),
      ),
    );
  }
}
