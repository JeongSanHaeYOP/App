import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../resultpage.dart';
import '../theme/colors.dart';

class SelectPerBottomSheet extends StatefulWidget {
  final Map<dynamic, dynamic> result;
  const SelectPerBottomSheet(this.result, {Key? key}) : super(key: key);

  @override
  State<SelectPerBottomSheet> createState() => _SelectPerBottomSheetState();
}

int num = 20;

class _SelectPerBottomSheetState extends State<SelectPerBottomSheet> {
  final _valueList = [for (var i = 0; i < num; i++) i + 1];
  int _selectedValue = 1;

  String _selectedBank = "직접 입력";
  final _bankList = [
    "국민",
    "기업",
    "농협",
    "새마을 금고",
    "신한",
    "우리",
    "하나",
    "카카오뱅크",
    "직접 입력"
  ];

  bool _isChecked = false;

  final TextEditingController _bankTextController = TextEditingController();
  @override
  void initState() {
    _bankTextController.addListener(() {
      print(_bankTextController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _bankTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          Center(
              child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: const Text(
              "정보",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )),
          const Divider(thickness: 1, height: 1, color: ColorStyles.mainGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "인원 수 입력",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                  width: 50,
                  height: 50,
                  child: DropdownButton(
                    elevation: 0,
                    autofocus: false,
                    focusColor: ColorStyles.subGreen,
                    dropdownColor: ColorStyles.subGrey,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    underline: Container(
                      height: 2,
                      color: ColorStyles.mainGreen,
                    ),
                    menuMaxHeight: 200,
                    value: _selectedValue,
                    items: _valueList.map((item) {
                      return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.toString(),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  )),
            ],
          ),
          const Divider(thickness: 1, height: 1, color: ColorStyles.mainGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "계좌 포함",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                  width: 50,
                  height: 50,
                  child: Switch(
                      activeColor: ColorStyles.mainGreen,
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value;
                        });
                      }))
            ],
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AbsorbPointer(
                    absorbing: !_isChecked,
                    child: SizedBox(
                        width: 100,
                        height: 50,
                        child: DropdownButton(
                          elevation: 0,
                          autofocus: false,
                          focusColor: ColorStyles.subGreen,
                          dropdownColor: ColorStyles.subGrey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          underline: Container(
                            height: 2,
                            color: ColorStyles.mainGreen,
                          ),
                          menuMaxHeight: 200,
                          value: _selectedBank,
                          items: _bankList.map((item) {
                            return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item.toString(),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBank = value!;
                            });
                          },
                        )),
                  ),
                  AbsorbPointer(
                    absorbing: !_isChecked,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      width: 200,
                      child: TextField(
                        decoration: const InputDecoration(hintText: "계좌 입력"),
                        controller: _bankTextController,
                      ),
                    ),
                  )
                ],
              ),
              if (!_isChecked)
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(color: Colors.white),
                )
            ],
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: ElevatedButton(
                    onPressed: () {
                      widget.result['num'] = _selectedValue;
                      widget.result['result'] =
                          (widget.result['sum'] / _selectedValue).round();
                      if (_isChecked) {
                        if (_selectedBank == "직접 입력") {
                          widget.result['bank'] = _bankTextController.text;
                          print("equals");
                        } else {
                          widget.result['bank'] =
                              "$_selectedBank ${_bankTextController.text}";
                        }
                      } else {
                        widget.result['bank'] = '';
                      }
                      Get.to(() => const ResultPage(),
                          arguments: widget.result);
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      splashFactory: NoSplash.splashFactory,
                      shadowColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return ColorStyles.subGreen; // 연한 초록
                          } else {
                            return ColorStyles.mainGreen; // 진한 초록
                          }
                        },
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                    ),
                    child: const Text("계속")),
              ),
            ),
          )
        ],
      ),
    );
  }
}
