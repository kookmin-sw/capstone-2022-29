// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields, unused_field, unused_element, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:frontend/pages/login/custom_join_page.dart';
import 'package:frontend/pages/login/custom_login_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _nativeAppKey = dotenv.get('NATIVE_APP_KEY');
  String method = '';

  static final FlutterKakaoLogin kakaoSignIn = FlutterKakaoLogin();
  bool _isLogined = false;
  String _accessToken = '';
  String _refreshToken = '';
  String _accountInfo = '';
  String _loginMessage = 'Not Logged In';

  @override
  void initState() {
    super.initState();
    loadKakao();
  }

  void loadKakao() async {
    await kakaoSignIn.init(_nativeAppKey);
  }

  // Kakao Login
  Future<void> flutterKakaoLogin() async {
    try {
      final logInResult = await kakaoSignIn.logIn();
      _processLoginResult(logInResult);

      // get User Info
      final result = await kakaoSignIn.getUserMe();
      final KakaoAccountResult? account = result.account;
      if (account != null) {
        final KakaoAccountResult? account = result.account!;
        // final userID = account?.userID;
        // final userEmail = account?.userEmail;
        final userNickname = account?.userNickname;
        final userProfileImagePath = account?.userProfileImagePath;
        debugPrint("userNickName: ${userNickname}");
        debugPrint("userProfileImagePath: ${userProfileImagePath}");
        debugPrint("token: ${_accessToken}");

        var user = await ApiService().getUserInfo(userNickname);
        if (user == null) {
          await ApiService().postUserInfo(
            User(
              accessToken: _accessToken,
              nickname: userNickname!,
              profile: userProfileImagePath!,
              id: '',
              password: '',
              // email: userEmail!,
            ),
          );
          var result = await ApiService().getUserInfo(userNickname);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigatorPage(
                index: 0,
                nickname: userNickname,
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
                nickname: userNickname,
                user_id: user['_id'],
                method: method,
              ),
            ),
          );

          await ApiService().updateUserInfo(
            userNickname,
            User(
              accessToken: _accessToken,
              nickname: userNickname!,
              profile: userProfileImagePath!,
              id: '',
              password: '',
            ),
          );
        }
      }
    } on PlatformException catch (e) {
      debugPrint("${e.code} ${e.message}");
    }
  }

  void _updateAccessToken(String accessToken) {
    setState(() {
      _accessToken = accessToken;
    });
  }

  void _updateRefreshToken(String refreshToken) {
    setState(() {
      _refreshToken = refreshToken;
    });
  }

  void _updateAccountMessage(String message) {
    setState(() {
      _accountInfo = message;
    });
  }

  void _updateStateLogin(bool isLogined, KakaoLoginResult result) async {
    setState(() {
      _isLogined = isLogined;
    });
    if (!isLogined) {
      _updateAccessToken('');
      _updateRefreshToken('');
      _updateAccountMessage('');

      debugPrint("Kakao login fail");
    } else {
      if (result.token != null && result.token!.accessToken != null) {
        _updateAccessToken(result.token!.accessToken!);
        _updateRefreshToken(result.token!.refreshToken!);
      }

      debugPrint("Kakao login success");
      debugPrint("access_token: $_accessToken");
      debugPrint("refresh_token: $_refreshToken");
      debugPrint("accountInfo: $_accountInfo");
    }
  }

  void _updateLoginMessage(String message) {
    setState(() {
      _loginMessage = message;
    });
  }

  void _processLoginResult(KakaoLoginResult result) {
    switch (result.status) {
      case KakaoLoginStatus.loggedIn:
        debugPrint('login');
        _updateLoginMessage('Logged In by the user.');
        _updateStateLogin(true, result);
        break;
      case KakaoLoginStatus.loggedOut:
        debugPrint('logout');
        _updateLoginMessage('Logged Out by the user.');
        _updateStateLogin(false, result);
        break;
      case KakaoLoginStatus.unlinked:
        debugPrint('unlink');
        _updateLoginMessage('Unlinked by the user');
        _updateStateLogin(false, result);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  height: size.height * 0.08,
                ),
                Container(
                  width: size.width * 0.57,
                  height: size.height * 0.05,
                  child: OutlinedButton(
                    child: Text('로그인하기'),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Color(0xffC6E4FF),
                      shadowColor: Colors.grey,
                      elevation: 2,
                      side: BorderSide.none,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomLoginPage()),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SignInButtonBuilder(
                  backgroundColor: Color(0xffF2E52D),
                  height: size.height * 0.05,
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
                SizedBox(
                  height: size.height * 0.04,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("계정이 없으신가요?"),
                  SizedBox(width: size.width * 0.02),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomJoinPage()),
                      );
                    },
                    child: Text("회원가입",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 23, 147, 255),
                        )),
                  )
                ])
              ])),
    );
  }
}
