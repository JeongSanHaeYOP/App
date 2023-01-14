import 'dart:ffi';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_jshy/theme/colors.dart';
import 'package:frontend_jshy/theme/styles.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

/// *
/// 결과페이지
///
/// N 입력하면 총액에서 나누기
///
/// *
var numFormat = NumberFormat('###,###,###,###');

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
            backgroundColor: ColorStyles.mainGreen,
          ),
          body: Center(
            child: Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  children: const [
                    BillCard(),
                    Text("카카오톡 공유 "),
                  ],
                )

                //Text("아이템: ${Get.arguments['items']}\n합계 : ${Get.arguments['sum']}"),
                ),
          )),
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
      elevation: 5,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleText("영수증", 20, 20, FontWeight.bold),
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                child: const Text(
                  "정산해욥",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              dotBorder(2),
              Container(
                padding: UiStyles.billsPadding,
                child: const Items(),
              ),
              dotBorder(1),
              billText("총합계", 17, 'sum', FontWeight.normal),
              dotBorder(1),
              billText("총 인원", 17, 'num', FontWeight.normal),
              dotBorder(2),
              billText("1인 지불 금액", 17, 'result', FontWeight.bold),
              Container(
                padding: UiStyles.itemsPadding,
              ),
              bankText(),
              // 계좌 같은 추가 정보
            ],
          )
          //Center(child: Text('아이템: ${Get.arguments['items'].length}\n합계 : ${Get.arguments['sum']}')),
          ),
    );
  }

  Widget dotBorder(int num) {
    return Column(
      children: [
        for (int i = 0; i < num; i++)
          Container(
            margin: const EdgeInsets.all(1),
            child: const DottedLine(
              lineLength: 250,
              lineThickness: 1,
              dashLength: 10,
            ),
          ),
      ],
    );
  }

  Widget bankText() {
    if (Get.arguments['bank'] != '') {
      return Column(
        children: [
          titleText("[계좌 정보]", 17, 10, FontWeight.normal),
          titleText(Get.arguments['bank'], 17, 10, FontWeight.bold),
        ],
      );
    } else {
      return titleText("송금해주세욥", 17, 10, FontWeight.normal);
    }
  }

  Widget billText(
      String title, double? titleSize, String type, FontWeight bold) {
    return Container(
        padding: UiStyles.billsPadding, // L T R B : 30, 10 , 30, 10
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            title,
            style: TextStyle(fontSize: titleSize, fontWeight: bold),
          ),
          Text(
            numFormat.format(Get.arguments[type]),
            style: TextStyle(fontSize: titleSize, fontWeight: bold),
          )
        ]));
  }

  Widget titleText(
      String title, double? titleSize, double margin, FontWeight bold) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: titleSize, fontWeight: bold),
        ),
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
        for (int i = 0; i < Get.arguments['items'].length; i++)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${Get.arguments['items'][i][0]}"),
                  Text(numFormat.format(Get.arguments['items'][i][1])),
                ],
              ),
              Container(
                padding: UiStyles.itemsPadding,
              )
            ],
          )
      ],
    );
  }
}
