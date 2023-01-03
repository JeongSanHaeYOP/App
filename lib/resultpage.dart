import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



/// *
/// 결과페이지
///
/// N 입력하면 총액에서 나누기
///
/// *


class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: const Color(0xff7FB77E),
        // ),
          body: Center(
              child: Text("결과 : ${Get.arguments}"),
          )
      ),
    );
  }
}
