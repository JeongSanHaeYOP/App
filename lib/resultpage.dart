import 'dart:ffi';
import 'dart:io';
// import 'dart:html';
import 'dart:typed_data';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend_jshy/theme/colors.dart';
import 'package:frontend_jshy/theme/styles.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:share_plus/share_plus.dart';

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
  var globalKey = GlobalKey();

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
                  children: [
                    RepaintBoundary(
                      key: globalKey,
                      child: const BillCard(),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                      child: Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                          ),
                          child: RawMaterialButton(
                            onPressed: () {
                              _capture();
                            },
                            elevation: 0.0,
                            focusElevation: 0.0,
                            fillColor: ColorStyles.mainGreen,
                            padding: const EdgeInsets.all(15.0),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.share,
                              size: 30,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    const Text("공유하기", style: TextStyle(fontSize: 10)),
                  ],
                )

                //Text("아이템: ${Get.arguments['items']}\n합계 : ${Get.arguments['sum']}"),
                ),
          )),
    );
  }

  void _capture() async {
    print("START CAPTURE");
    var renderObject = globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final directory = (await getApplicationDocumentsDirectory()).path;
      print(directory);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      print(pngBytes);
      File imgFile = File('$directory/screenshot.png');
      print("FINISH CAPTURE ${imgFile}");
      imgFile.writeAsBytes(pngBytes!);
      // var imgFile = File.fromRawPath(pngBytes!);
      if (imgFile != null) {
        _shareBill(imgFile);
      }
    }
  }

  void _shareBill(File file) {
    String text;
    if (Get.arguments['bank'] != '') {
      text = "정산해욥:: ${Get.arguments['bank']}";
    } else {
      text = "정산해욥";
    }

    if (Platform.isAndroid) {
      print("Android");
      Share.shareXFiles([XFile(file.path)], text: text);
    } else {
      print("IOS");
      var box = globalKey.currentContext?.findRenderObject() as RenderBox?;
      Share.shareXFiles([XFile(file.path)],
          text: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
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
              billText("합계", 17, 'sum', FontWeight.normal),
              dotBorder(1),
              billText("총 인원", 17, 'num', FontWeight.normal),
              dotBorder(2),
              billText("1인 금액", 17, 'result', FontWeight.bold),
              Container(
                padding: UiStyles.itemsPadding,
              ),
              bankText(),
              Container(
                padding: UiStyles.itemsPadding,
              ),
              Container(
                padding: UiStyles.itemsPadding,
              ),
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
