import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// 결과 페이지: OCR 결과 화면
/// 1. 디자인
/// 2. OCR 결과 - 체크박스 형태
/// 3. 체크박스 클릭 되면 결과 박스에 덧셈

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}



final List<String> imgList = [
  'assets/images/img1.png',
  'assets/images/img2.png',
  'assets/images/img3.png'
];


/// MAP 아닌 리스트로 따로 할당해주어야할듯?..
/// 중복이 있을 수 있기 때문에..
/// -> 해결
///
/// OCR 결과 전달해줄때, 따로따로 주어야할듯.. ***

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 캡쳐 이미지가 들어간 박스
          imageBox(context),
          // 가격 텍스트가 들어간 박스
          // const PriceListView(),
          // // 결과 값이 들어간 박스 (총액)
          // resultTextView(context),
          CalculatePrice()
        ],
      );
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
    height: 450,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Swiper(
        control: const SwiperControl(color: Color(0xff7FB77E)),
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
              color: Colors.grey, activeColor: Color(0xff7FB77E)),
        ),
        itemCount: imgList.length,
        itemBuilder: (BuildContext context, int index){
          return Image.asset(imgList[index], fit: BoxFit.fitHeight);
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


final List<String> itemList = [
  "GS25 위더뷰중앙", "주식회사 써브원", "이지윤", "주식회사 우아한형제", "임세희", "임세희", "주식회사 카카오"
];

final List<int> priceList = [
  4000, 8400, 150000, 15900, 2500, 15000, 3510
];

final List<bool> checkList = [
  false, false, false, false, false, false, false
];

class CalculatePrice extends StatefulWidget {
  const CalculatePrice({Key? key}) : super(key: key);

  @override
  State<CalculatePrice> createState() => _CalculatePriceState();
}

class _CalculatePriceState extends State<CalculatePrice> {
  int sum = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Color(0xff7FB77E),
                      width: 3
                  ),
                  bottom: BorderSide(
                      color: Color(0xff7FB77E),
                      width: 3
                  )
              )
          ),
          width: 350,
          height: 180,
          child: Scrollbar(
            thickness: 4.0, // 스크롤 너비
            isAlwaysShown: true,
            radius: const Radius.circular(8.0), // 스크롤 라운딩
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for(int i = 0; i < itemList.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(itemList[i]),
                            Row(
                              children: [
                                Text(priceList[i].toString()),
                                Checkbox(value: checkList[i], onChanged: (value) => {
                                  setState(() {
                                    checkList[i] = value!;
                                    if(value == true) {
                                      sum = sum + priceList[i];
                                    } else {
                                      sum = sum - priceList[i];
                                    }
                                  })
                                })
                              ],
                            )
                          ],
                        ),
                    ],
                  )
                ],
              ).toList(),
            ),
          ),
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
                ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStateProperty.resolveWith(
                            (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return const Color(0xffB1D7B4);
                          } else {
                            return const Color(0xff7FB77E);
                          }
                        },
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          )
                      ),
                    ),
                    child: const Text("1/N"))
              ],
            )
        )
      ],
    );
  }
}


