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
        appBar: AppBar(
          backgroundColor: const Color(0xff7FB77E),
        ),
          body: Center(
              child: Container(
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      BillCard(),
                      TextButton(onPressed: () {}, child: Text("1/N")),
                    ],
                  )

                   //Text("아이템: ${Get.arguments['items']}\n합계 : ${Get.arguments['sum']}"),
              ),
          )
      ),
    );
  }
}

class BillCard extends StatefulWidget {
  const BillCard({Key? key}) : super(key: key);

  @override
  State<BillCard> createState() => _BillCardState();
}

class _BillCardState extends State<BillCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox (
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Text("영수증"),
              ),
              Items(),
              Container(
                margin: EdgeInsets.all(20),
                child: Text("합계 : ${Get.arguments['sum']}"),
              ),
            ],
          )
        //Center(child: Text('아이템: ${Get.arguments['items'].length}\n합계 : ${Get.arguments['sum']}')),
        ),
    );
  }
}

class Items extends StatelessWidget {
  const Items({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          for(int i = 0; i < Get.arguments['items'].length; i ++)
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "${Get.arguments['items'][i][0]}"
            ),
            Text(
                "${Get.arguments['items'][i][1]}"
            ),
          ],
        ),
      ],
    );

  }
}


