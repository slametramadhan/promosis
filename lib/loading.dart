import 'dart:async';

import 'package:flutter/material.dart';
import 'package:promosi/mainpage.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void initState() {
    super.initState();
    Timer(
        Duration(milliseconds: 2500),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: AssetImage('image/kendari.jpg'))),
      child: Container(),
    );
  }
}
