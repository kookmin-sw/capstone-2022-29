// ignore_for_file: prefer_final_fields

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';

class KakaoSignInAPI {
  static String _nativeAppKey = dotenv.get('NATIVE_APP_KEY');
  static final FlutterKakaoLogin kakaoSignIn = FlutterKakaoLogin();

  static Future init() => kakaoSignIn.init(_nativeAppKey);
  static Future<KakaoLoginResult> login() => kakaoSignIn.logIn();
  static Future<KakaoLoginResult> getUserMe() => kakaoSignIn.getUserMe();
  static Future logout() => kakaoSignIn.logOut();
}
