import 'dart:ffi';
import 'dart:io';
// import 'dart:html';
import 'dart:typed_data';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend_jshy/main.dart';
import 'package:frontend_jshy/theme/colors.dart';
import 'package:frontend_jshy/theme/styles.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:share_plus/share_plus.dart';

import 'mainpage.dart';

/// *
/// 결과페이지
///
/// N 입력하면 총액에서 나누기
///
/// 돈 시간 ㄱㄱ///
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
    return WillPopScope(
        onWillPop: () {
          return _onBackKey('BACK');
        },
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          home: Scaffold(
              appBar: AppBar(
                backgroundColor: ColorStyles.mainGreen,
                leading: IconButton(
                    onPressed: () async {
                      if (await _onBackKey('BACK')) {
                        Get.back();
                      }
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              body: Center(
                child: Container(
                    margin: const EdgeInsets.all(30),
                    child: ListView(
                      children: [
                        RepaintBoundary(
                          key: globalKey,
                          child: const BillCard(),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              resultButton("HOME"),
                              resultButton("SHARE"),
                            ],
                          ),
                        )
                      ],
                    )

                    //Text("아이템: ${Get.arguments['items']}\n합계 : ${Get.arguments['sum']}"),
                    ),
              )),
        ));
  }

  Widget resultButton(String type) {
    String title = 'NONE';
    var icon = Icons.highlight_off;
    if (type == 'SHARE') {
      title = '공유하기';
      icon = Icons.share;
    } else if (type == 'HOME') {
      title = '돌아가기';
      icon = Icons.home_filled;
    }
    return Column(
      children: [
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
                  getByTypes(type);
                },
                elevation: 0.0,
                focusElevation: 0.0,
                fillColor: ColorStyles.mainGreen,
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
              )),
        ),
        Text(title, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  void getByTypes(String type) {
    if (type == 'SHARE') {
      _capture();
    } else if (type == 'HOME') {
      _goHome();
    } else {
      return;
    }
  }

  void _capture() async {
    print("START CAPTURE");
    var renderObject = globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      File imgFile = File('$directory/screenshot.png');
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

  void _goHome() {
    _onBackKey('HOME');
    // Get.offAll(() => const MainApp());
  }

  Future<bool> _onBackKey(String type) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            actionsPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            backgroundColor: Colors.white,
            title: const Text(
              '지금 돌아가면 현재 내용이 삭제 됩니다. ',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            actions: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (type == 'BACK') {
                              Navigator.pop(context, true);
                            } else if (type == 'HOME') {
                              Get.offAll(() => const MainApp());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: ColorStyles.mainGreen,
                            shadowColor: Colors.transparent,
                            alignment: Alignment.center,
                            disabledBackgroundColor: ColorStyles.subGreen,
                            // padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "돌아가기",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          )),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          style: OutlinedButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            alignment: Alignment.center,
                            disabledBackgroundColor: ColorStyles.subGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: const Text(
                            "취소",
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                            ),
                          )),
                    )
                  ],
                ),
              )
            ],
          );
        });
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
