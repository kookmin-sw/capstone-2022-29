import 'package:flutter/material.dart';

class CheckValidate {
  String? validateNickname(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '닉네임을 입력하세요.';
    } else {
      String pattern = r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]{3,8}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '3자 이상 8자 이내의 한글, 영어, 숫자로 입력하세요.';
      } else {
        return null;
      }
    }
  }

  String? validateId(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return 'ID를 입력하세요.';
    } else {
      String pattern = r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]{3,8}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '3자 이상 8자 이내의 한글, 영어, 숫자로 입력하세요.';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      String pattern = r'^[A-Za-z0-9]{8,15}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '영어, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      } else {
        return null;
      }
    }
  }
}
