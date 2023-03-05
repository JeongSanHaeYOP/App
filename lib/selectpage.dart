import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:frontend_jshy/main.dart';
import 'package:frontend_jshy/mainpage.dart';
import 'package:frontend_jshy/resultpage.dart';
import 'package:frontend_jshy/theme/colors.dart';
import 'package:frontend_jshy/widgets/subwidgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

/// 결과 페이지: OCR 결과 화면
/// 1. 디자인
/// 2. OCR 결과 - 체크박스 형태
/// 3. 체크박스 클릭 되면 결과 박스에 덧셈
///
///
/// 모두 선택 기능 추가??
// 'assets/images/img1.png',
// 'assets/images/img2.png',
// 'assets/images/img3.png'
List<File> imgList = [];
List<String> _itemList = [];
List<int> _priceList = [];

var numFormat = NumberFormat('###,###,###,###');

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  @override
  Widget build(BuildContext context) {
    // 이미지, 결과 받아오기
    imgList = Get.arguments['img'];
    var result = Get.arguments['result'];
    final item = result['item']?.cast<String>();
    final price = result['price']?.cast<int>();
    if (item != null && price != null) {
      _itemList = item;
      _priceList = price;
    }
    print(_itemList);
    print(_priceList);
    return WillPopScope(
        onWillPop: () {
          return _onBackKey();
        },
        child: MaterialApp(
          theme: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: ColorStyles.mainGreen,
                leading: IconButton(
                    onPressed: () async {
                      if (await _onBackKey()) {
                        Get.back();
                      }
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              body: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 캡쳐 이미지가 들어간 박스
                    imageBox(context),
                    // TextButton(onPressed: () {}, child: Text("이미지 추가")),
                    // 가격 텍스트와 총액이 들어간 박스
                    const Expanded(child: CalculatePrice())
                  ],
                ),
              )),
        ));
  }

  Future<bool> _onBackKey() async {
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
                            imgList = [];
                            _priceList = [];
                            _itemList = [];
                            Navigator.pop(context, true);
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

/// *
///  캡쳐 이미지 박스
///  1. Swiper 기능으로 사진 여러장 띄우기 ( OCR에서 여러장 인식하는 거 구현 )
///  2. 받아온 사진 그대로기나타내기
///  imgList -> 사진이 들어간 리스트
/// *
///
Widget imageBox(BuildContext context) {
  return SizedBox(
    // 이미지가 들어간 박스
    height: 400,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Swiper(
        control: const SwiperControl(color: ColorStyles.mainGreen),
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
              color: Colors.grey, activeColor: ColorStyles.mainGreen),
        ),
        itemCount: imgList.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.file(imgList[index], fit: BoxFit.contain);
        },
      ),
    ),
  );
}

/// *
/// [ 내역 : 금액 : 체크박스 ] 형태의 값 ListView
/// 1. 위에 구분 선
/// itemList -> 내역
/// priceList -> 금액
///
/// 총액을 알려주는 text box
/// 1/N 해주는 화면으로 넘어가는 버튼 추가 해야함!!
/// *
///

/// MAP 아닌 리스트로 따로 할당해주어야할듯?..
/// 중복이 있을 수 있기 때문에..
/// -> 해결
///
/// OCR 결과 전달해줄때, 따로따로 주어야할듯.. ***

// final List<bool> checkList = [
//   false, false, false, false, false, false, false
// ];

class CalculatePrice extends StatefulWidget {
  const CalculatePrice({Key? key}) : super(key: key);

  @override
  State<CalculatePrice> createState() => _CalculatePriceState();
}

class _CalculatePriceState extends State<CalculatePrice> {
  int sum = 0;
  List<int> priceList = _priceList;
  List<String> itemList = _itemList;
  var checkList = List<bool>.filled(_itemList.length, false, growable: true);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        newTextField(),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: ColorStyles.mainGreen, width: 3),
                    bottom:
                        BorderSide(color: ColorStyles.mainGreen, width: 3))),
            width: 350,
            constraints: const BoxConstraints(
              maxHeight: 150,
            ),
            child: itemPriceList(_itemList, _priceList)),
        Container(
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "총액 : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  numFormat.format(sum),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          var items = [];
                          for (int i = 0; i < checkList.length; i++) {
                            if (checkList[i]) {
                              var item = [_itemList[i], _priceList[i]];
                              items.add(item);
                            }
                          }
                          Map result = {'items': items, 'sum': sum};
                          Get.bottomSheet(SelectPerBottomSheet(result));
                        },
                        style: ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                          shadowColor: const MaterialStatePropertyAll(
                              Colors.transparent),
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return ColorStyles.subGreen; // 연한 초록
                              } else {
                                return ColorStyles.mainGreen; // 진한 초록
                              }
                            },
                          ),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                        child: const Text("1/N")))
              ],
            )),
      ],
    );
  }

  Widget itemPriceList(List<String> item, List<int> price) {
    return Scrollbar(
      thickness: 4.0, // 스크롤 너비
      isAlwaysShown: true,
      radius: const Radius.circular(8.0), // 스크롤 라운딩
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        // reverse: true,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < price.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item[i]),
                  Row(
                    children: [
                      Text(numFormat.format(price[i])),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Checkbox(
                            activeColor: ColorStyles.mainGreen,
                            splashRadius: 0,
                            value: checkList[i],
                            onChanged: (value) => {
                                  setState(() {
                                    checkList[i] = value!;
                                    if (value == true) {
                                      sum = sum + price[i];
                                    } else {
                                      sum = sum - price[i];
                                    }
                                  })
                                }),
                      )
                    ],
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget newTextField() {
    TextEditingController itemTextController = TextEditingController();
    TextEditingController priceTextController = TextEditingController();
    String item = "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 100,
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "사용처",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorStyles.subGreen, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorStyles.mainGreen, width: 2),
              ),
              contentPadding: EdgeInsets.all(5),
            ),
            cursorColor: ColorStyles.mainGreen,
            controller: itemTextController,
          ),
        ),
        SizedBox(
          width: 100,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
            ],
            decoration: const InputDecoration(
                hintText: "금액",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.subGreen, width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorStyles.mainGreen, width: 2),
                ),
                focusColor: ColorStyles.mainGreen,
                contentPadding: EdgeInsets.all(5)),
            cursorColor: ColorStyles.mainGreen,
            controller: priceTextController,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextButton(
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              setState(() {
                if (itemTextController.text == "") {
                  item = "추가 항목";
                } else {
                  item = itemTextController.text;
                }
                print(item);
                if (priceTextController.text.isEmpty) {
                  Get.snackbar("정산해욥", "금액을 입력해주세요",
                      backgroundColor: Colors.white70,
                      icon: const Icon(
                        Icons.warning_amber_rounded,
                        color: ColorStyles.mainGreen,
                        size: 30,
                      ),
                      shouldIconPulse: false);
                } else {
                  _priceList.add(int.parse(priceTextController.text));
                  sum = sum + int.parse(priceTextController.text);
                  _itemList.add(item);
                  checkList.add(true);
                }
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent + 50);
              });
            },
            child: const Text(
              "추가",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorStyles.mainGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class NewPrice extends StatefulWidget {
//   const NewPrice({Key? key}) : super(key: key);
//
//   @override
//   State<NewPrice> createState() => _NewPriceState();
// }
//
// class _NewPriceState extends State<NewPrice> {
//   bool isChecked = false;
//   int num = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           width: 100,
//           child: const TextField(
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               hintText: "사용처",
//             ),),
//         ),
//         Row(
//           children: [
//             Container(
//               width: 100,
//               child: TextField(
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
//                 decoration: const InputDecoration(
//                   hintText: "가격",
//                 ),
//                 onChanged: (val) => {
//                   num = int.parse(val)
//                 },
//               ),
//             ),
//             Checkbox(value: isChecked, onChanged: (value) => {
//               setState(() {
//                 isChecked = value!;
//                 if(value == true) {
//                   sum = sum + num;
//                 } else {
//                   sum = sum - num;
//                 }
//               })
//             })
//           ],
//         ),
//       ],
//     );;
//   }
// }
