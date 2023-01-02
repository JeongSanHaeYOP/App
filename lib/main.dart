import 'package:flutter/material.dart';
import 'package:frontend_jshy/mainpage.dart';
import 'package:frontend_jshy/selectpage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: const Color(0xff7FB77E),
          // ),
          body: Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: const MainPage()
          )
      ),
    );
  }
}
