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

final Map resultMap = {
  "GS25 위더뷰중앙" : 4000,
  "주식회사 써브원" : 8400,
  "이지윤" : 150000,
  "주식회사 우아한형제" : 15900,
  "임세희" : 2500,
  "임세희" : 15000,
  "주식회사 카카오" : 3510
};

int? sumValues(List price) {
  int? sum = 0;
  for(int i = 0; i < price.length; i ++) {
    sum = (sum! + price[i]) as int?;
  }

  return sum;
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
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
          ),
          // 텍스트가 들어간 박스
          Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Color(0xff7FB77E),
                          width: 3
                      ))
              ),
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for(int i = 0; i < 3; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(resultMap.keys.toList()[i]),
                        Row(
                          children: [
                            Text(resultMap.values.toList()[i].toString()),
                            const Checkbox(value: true, onChanged: null)
                          ],
                        )
                      ],
                    ),
                ],)
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Color(0xff7FB77E),
                          width: 3
                      ))
              ),
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("총액 : "),
                          Text(sumValues(resultMap.values.toList()).toString()),
                        ],
                      )
                  )
                ],)
          )
        ],
      );
  }
}

Widget priceListView(BuildContext context) {
  return ListView(
    children: ListTile.divideTiles(
      context: context,
      tiles: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for(int i = 0; i < 3; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(resultMap.keys.toList()[i]),
                  Row(
                    children: [
                      Text(resultMap.values.toList()[i].toString()),
                      const Checkbox(value: true, onChanged: null)
                    ],
                  )
                ],
              ),
          ],)
      ],
    ).toList(),
  );
}


