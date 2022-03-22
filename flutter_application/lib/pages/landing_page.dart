// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff5964E1),
        body: Center(
          // child: SvgPicture.asset('lib/assets/logo.svg'),
          child: Container(
            height: size.height * 0.3,
            // width: size.width * 0.5,
            child: Image.asset('lib/assets/logo.png'),
          ),
        ),
      ),
    );
  }
}
