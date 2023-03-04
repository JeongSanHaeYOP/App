import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_jshy/mainpage.dart';
import 'package:frontend_jshy/selectpage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  await dotenv.load(fileName: "assets/config/.env");
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
              child: const MainPage())),
    );
  }
}

// 돌아가기용
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: const Color(0xff7FB77E),
        // ),
        body: Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: const MainPage()));
  }
}
