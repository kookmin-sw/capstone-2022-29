// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:convert';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/pages/login/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _apiURI = dotenv.get('API_URI');

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future fetch() async {
    final response = await http.get(
      Uri.parse('http://' + _apiURI),
    );

    if (response.statusCode == 200) {
      print(response.body);

      Timer(Duration(milliseconds: 1000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffC6E4FF),
                Colors.white,
              ],
              stops: [0.0, 0.9177],
            ),
          ),
          child: Image.asset('lib/assets/images/landing.png'),
        ),
      ),
    );
  }
}
