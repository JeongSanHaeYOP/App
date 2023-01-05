import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_jshy/resultpage.dart';
import 'package:frontend_jshy/theme/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    _itemList.add("예시");
    _priceList.add(73);
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
              resizeToAvoidBottomInset : false,
              appBar: AppBar(
                backgroundColor: ColorStyles.mainGreen,
                leading: IconButton(
                    onPressed: () async {
                      if(await _onBackKey()) {
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
                  children: const [
                    // 가격 텍스트와 총액이 들어간 박스
                    Expanded(child: CalculatePrice())
                  ],
                ),
              )
          ),
        )
    );
  }

  Future<bool> _onBackKey() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            actionsPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                          )
                      ),
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
                         )
                     ),
                   )
                  ],
                ),
              )
            ],
          );
        });
  }
}

List<String> _itemList = [];
List<int> _priceList = [];


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


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: newTextField(),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: ColorStyles.mainGreen,
                        width: 3
                    ),
                    bottom: BorderSide(
                        color: ColorStyles.mainGreen,
                        width: 3
                    )
                )
            ),
            width: 350,
            child: itemPriceList(_itemList, _priceList)
        ),
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
                  sum.toString(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        for(int i = 0; i < checkList.length; i++) {
                          if(checkList[i]){
                            var item = [_itemList[i], _priceList[i]];
                            items.add(item);
                            print(item);
                          }
                        }
                        Map result = {'items' : items, 'sum' : sum };
                        print(result);
                        Get.to(() => const ResultPage(), arguments: result);
                      },
                      style: ButtonStyle(
                        foregroundColor: const MaterialStatePropertyAll(Colors.white),
                        splashFactory: NoSplash.splashFactory,
                        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
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
                                borderRadius: BorderRadius.circular(20.0)
                            )
                        ),
                      ),
                      child: const Text("1/N")
                  ),
                )
              ],
            )
        ),
      ],
    );
  }

  var a = [];
  Widget itemPriceList(List<String> item, List<int> price) {
    return Scrollbar(
      thickness: 4.0, // 스크롤 너비
      isAlwaysShown: true,
      radius: const Radius.circular(8.0), // 스크롤 라운딩
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < price.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item[i]),
                  Row(children: [
                    Text(price[i].toString()),
                    Checkbox(
                      activeColor: ColorStyles.mainGreen,
                      splashRadius: 0,
                      value: checkList[i],
                      onChanged: (value) => {
                        setState(() {
                          checkList[i] = value!;
                          if(value == true) {
                            sum = sum + price[i];
                          } else {
                            sum = sum - price[i];
                          }
                        })
                      },)
                  ],)
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
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
            decoration: const InputDecoration(
                hintText: "금액",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.subGreen, width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.mainGreen, width: 2),
                ),
                focusColor: ColorStyles.mainGreen,
                contentPadding: EdgeInsets.all(5)
            ),
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
                _priceList.add(int.parse(priceTextController.text));
                if(itemTextController.text == "") {
                  item = "추가 항목";
                } else {
                  item = itemTextController.text;
                }
                _itemList.add(item);
                checkList.add(true);
                sum = sum + int.parse(priceTextController.text);
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
