import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 결과 페이지: OCR 결과 화면
/// 1. 디자인
/// 2. OCR 결과 - 체크박스 형태
/// 3. 체크박스 클릭 되면 결과 박스에 덧셈

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            const SizedBox(
                height: 100,
                width: 100,
                child: Text("안녕하세요")
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


