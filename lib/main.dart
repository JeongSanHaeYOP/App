import 'package:flutter/material.dart';
import 'package:frontend_jshy/mainpage.dart';
import 'package:frontend_jshy/resultpage.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: const Color(0xff7FB77E),
          // ),
          body: Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: const ResultPage()
          )
      ),
    );
  }
}
