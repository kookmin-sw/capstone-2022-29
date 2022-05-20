// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields, unused_field, unused_element, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/api/kakao_signin_api.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/navigator.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _nativeAppKey = dotenv.get('NATIVE_APP_KEY');
  String method = '';

  Future<void> flutterKakaoLogin() async {
    await KakaoSignInAPI.init();
    final _logInResult = await KakaoSignInAPI.login();
    if (_logInResult.status == KakaoLoginStatus.loggedIn) {
      final kakaoUser = await KakaoSignInAPI.getUserMe();
      if (kakaoUser.account == null) {
        debugPrint('Kakao Sign in Failed');
      } else {
        var user =
            await ApiService().getUserInfo(kakaoUser.account!.userNickname);
        if (user == null) {
          await ApiService().postUserInfo(
            User(
              accessToken: kakaoUser.token!.accessToken!,
              nickname: kakaoUser.account!.userNickname!,
              profile: kakaoUser.account!.userProfileImagePath!,
            ),
          );

          var result =
              await ApiService().getUserInfo(kakaoUser.account!.userNickname);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigatorPage(
                index: 0,
                nickname: kakaoUser.account!.userNickname,
                user_id: result['_id'],
                method: method,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigatorPage(
                index: 0,
                nickname: kakaoUser.account!.userNickname,
                user_id: user['_id'],
                method: method,
              ),
            ),
          );

          await ApiService().updateUserInfo(
            kakaoUser.account!.userNickname,
            User(
              accessToken: kakaoUser.token!.accessToken!,
              nickname: kakaoUser.account!.userNickname!,
              profile: kakaoUser.account!.userProfileImagePath!,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffC6E4FF),
              Color(0xffFFFFFF),
            ],
            stops: [0.0, 0.9177],
          ),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: Container(
                height: size.height * 0.45,
                child: Image.asset('lib/assets/images/logo.png'),
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            button(size, '로그인', (){Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NavigatorPage(
                    index: 10,
                    // query: widget.title,
                    // user_id: widget.user_id,
                    // nickname: widget.nickname,
                    // news_id: widget.news_id,
                  );
                },
              ),
            );}),
            button(size, '회원가입', (){Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NavigatorPage(
                    index: 11,
                    // query: widget.title,
                    // user_id: widget.user_id,
                    // nickname: widget.nickname,
                    // news_id: widget.news_id,
                  );
                },
              ),
            );}),
            SignInButtonBuilder(
              backgroundColor: Color(0xffF2E52D),
              onPressed: () {
                method = 'kakao';
                flutterKakaoLogin();
              },
              text: "카카오 계정으로 로그인",
              textColor: Colors.black,
              image: Container(
                height: size.height * 0.02,
                padding: EdgeInsets.only(left: size.width * 0.005),
                child: Image.asset('lib/assets/images/kakao_logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
