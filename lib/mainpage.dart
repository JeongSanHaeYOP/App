import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 메인페이지: 사진 업로드 화면
/// 1. 디자인
/// 2. 사진 업로드 후 OCR 모델로 전송
/// 3. 다음 페이지에 사진 전달

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            SizedBox(
                height: 100,
                width: 100,
                child: RawMaterialButton(
                  onPressed: () {},
                  elevation: 2.0,
                  fillColor: const Color(0xff7FB77E),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.image,
                    size: 70,
                    color: Colors.white,
                  ),
                )
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                    children: <Widget> [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: const Text("정산할 금액이 들어간",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      const Text("이미지를 선택해 주세요.",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    ]
                )
            )
          ]
      ),
    );
  }
}


