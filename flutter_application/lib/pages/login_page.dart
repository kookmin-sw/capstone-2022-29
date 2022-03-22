// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff5964E1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: size.height * 0.2,
                child: Image.asset('lib/assets/logo.png'),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SignInButtonBuilder(
              backgroundColor: Color(0xff63B897),
              onPressed: () {},
              text: "Sign in with Phone",
              icon: Icons.phone,
            ),
            SignInButton(Buttons.Google, onPressed: () {}),
            SignInButton(Buttons.FacebookNew, onPressed: () {}),
            SignInButtonBuilder(
              backgroundColor: Color(0xffF2E52D),
              onPressed: () {},
              text: "Sign in with Kakao",
              textColor: Colors.black,
              image: Container(
                height: size.height * 0.025,
                child: Image.asset('lib/assets/kakao_logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
