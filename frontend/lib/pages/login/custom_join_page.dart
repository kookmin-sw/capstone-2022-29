// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/login/custom_login_page.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/pages/login/validator.dart';

class CustomJoinPage extends StatefulWidget {
  CustomJoinPage({Key? key}) : super(key: key);

  @override
  State<CustomJoinPage> createState() => _CustomJoinPageState();
}

class _CustomJoinPageState extends State<CustomJoinPage> {
  FocusNode _nicknameFocus = FocusNode();
  FocusNode _idFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  String nickname = '';
  String id = '';
  String password = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onClickPressed() async {
    if (formKey.currentState!.validate()) {
      print('nickname: $nickname, id: $id, password: $password');
      await ApiService().postUserInfo(User(
        accessToken: 'accessToken',
        nickname: nickname,
        profile: 'profile',
        id: id,
        password: password,
      ));
      Navigator.pop(context);
    } else {
      formKey.currentState!.validate();
    }
  }

  Widget _showNicknameInput(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: _nicknameFocus,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: size.height * 0.01),
          hintText: 'Ex. 뉴익123',
          // helperText: '3자 이상 8자 이내의 한글, 영어, 숫자로 입력하세요',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Color.fromARGB(255, 23, 147, 255)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 23, 147, 255)),
              borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.emoji_emotions_outlined),
        ),
        validator: (value) =>
            CheckValidate().validateNickname(_nicknameFocus, value!),
        onChanged: (value) {
          nickname = value;
        },
        onSaved: (input) => nickname = input!,
      ),
    );
  }

  Widget _showIdInput(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: _idFocus,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: size.height * 0.01),
          hintText: 'news123',
          helperText: '3자 이상 8자 이내의 한글, 영어, 숫자로 입력하세요',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Color.fromARGB(255, 23, 147, 255)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 23, 147, 255)),
              borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(
            Icons.person_outline,
          ),
        ),
        validator: (value) => CheckValidate().validateId(_idFocus, value!),
        onChanged: (value) {
          id = value;
        },
      ),
    );
  }

  Widget _showPasswordInput(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      child: TextFormField(
        focusNode: _passwordFocus,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: size.height * 0.01),
          hintText: '**********',
          helperText: '영어, 숫자 포함 8자 이상 15자 이내로 입력하세요',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Color.fromARGB(255, 23, 147, 255)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 23, 147, 255)),
              borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.lock_outline_rounded),
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF7F7F7),
      appBar: appBar(size, ' ', context, true, false, () {}),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Container(
            margin:
                EdgeInsets.fromLTRB(size.width * 0.08, 0, size.width * 0.08, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  "회원가입",
                  style: TextStyle(
                      fontSize: size.width * 0.08, fontWeight: FontWeight.bold),
                )),
                SizedBox(height: size.height * 0.05),
                Text("Nickname"),
                _showNicknameInput(size),
                SizedBox(height: size.height * 0.03),
                Text(
                  "ID",
                  textAlign: TextAlign.left,
                ),
                _showIdInput(size),
                SizedBox(height: size.height * 0.03),
                Text(
                  "Password",
                  textAlign: TextAlign.left,
                ),
                _showPasswordInput(size),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Center(
                  child: SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.05,
                    child: OutlinedButton(
                      child: Text('회원가입'),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Color(0xffC6E4FF),
                        shadowColor: Colors.grey,
                        elevation: 2,
                        side: BorderSide.none,
                      ),
                      onPressed: onClickPressed,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("이미 계정이 있으신가요?"),
                  SizedBox(width: size.width * 0.02),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomLoginPage()),
                      );
                    },
                    child: Text("로그인",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 23, 147, 255),
                        )),
                  )
                ]),
                SizedBox(height: size.height * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
