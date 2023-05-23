import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend_jshy/main.dart';
import 'package:frontend_jshy/selectpage.dart';
import 'package:frontend_jshy/theme/colors.dart';
import 'package:frontend_jshy/widgets/loading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_crop/multi_image_crop.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:multi_crop_picker/picker.dart';
// import 'package:multi_image_crop/multi_image_crop.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'inputpage.dart';

/// 메인페이지: 사진 업로드 화면
/// 1. 디자인
/// 2. 사진 업로드 후 OCR 모델로 전송
/// 3. 다음 페이지에 사진 전달

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = false;
  // var ocrUrl = FlutterConfig.get('OCR_URL');
  // var apiKey = FlutterConfig.get('API_KEY');
  var ocrUrl = dotenv.env['OCR_URL'];
  var apiKey = dotenv.env['API_KEY'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Stack(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: getInputButton(),
                ),
                getImageButton(),
              ]),
          if (_isLoading) const Loading()
        ],
      )),
    );
  }

  // XFile? _image;
  // CroppedFile? _croppedImage;

  late List<XFile?> _imgList;
  final List<CroppedFile?> _croppedImgList = [];

  Future<void> getImage() async {
    // Initialized croppedImageList
    _croppedImgList.clear();
    // for gallery
    var imgList = await ImagePicker().pickMultiImage();
    if (imgList != null) {
      setState(() {
        _imgList = imgList!;
      });
    }

    if (_imgList.isNotEmpty) {
      _isLoading = true;
      cropImage();
    }
  }

  Future<void> cropImage() async {
    if (_imgList.isNotEmpty) {
      // 고른 이미지들 각각 크롭 액티비티 돌리기
      for (int i = 0; i < _imgList.length; i++) {
        var croppedImage = await ImageCropper().cropImage(
          sourcePath: _imgList[i]!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: '',
                toolbarColor: ColorStyles.mainGreen,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: '',
            ),
          ],
        );
        _isLoading = true;
        if (croppedImage != null) {
          setState(() {
            _croppedImgList.add(croppedImage);
          });
        }
      }
      _isLoading = false;

      List<File> imageFileList = [];
      for (int i = 0; i < _croppedImgList.length; i++) {
        imageFileList.add(File(_croppedImgList[i]!.path));
      }

      if (_croppedImgList.isNotEmpty) {
        var b = [];
        List splitData = [];
        for (int i = 0; i < _croppedImgList.length; i++) {
          var a = await getImageToText(_croppedImgList[i]);
          // b.add(a);
          var tmp = a.split("\r\n");
          for (var item in tmp) {
            splitData.add(item);
          }
        }
        _isLoading = false;
        List<String> itemList = [];
        List<int> priceList = [];
        var num = 0;
        var price = '';
        for (var item in splitData) {
          if (item.contains('-') ||
              item.contains('원') ||
              item.contains(',') ||
              item.contains('출금')) {
            price = item.replaceAll('-', '');
            price = price.replaceAll('원', '');
            price = price.replaceAll('출금', '');
            price = price.replaceAll(',', '');

            try {
              priceList.add(int.parse(price));
              num++;
              itemList.add('항목 $num');
            } catch (e) {
              print(e);
              continue;
            }
          }
        }
        var result = {'item': itemList, 'price': priceList};
        nextPage(imageFileList, result);
        // Get.to(() => const Loading());
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> getImageToText(cropFile) async {
    _isLoading = true;
    var bytes = File(cropFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = ocrUrl;
    var payload = {
      "base64Image": "data:image/jpg;base64,${img64.toString()}",
      "language": "kor"
    };
    Map<String, String>? header = {"apikey": apiKey!};

    var post = await http.post(Uri.parse(url!), body: payload, headers: header);
    var result = jsonDecode(post.body);

    return result['ParsedResults'][0]['ParsedText'];
  }

  void nextPage(List<File> images, Map result) {
    if (images.isEmpty) {
      _isLoading = false;
      Get.to(() => const MainPage());
    } else {
      Get.to(() => const SelectPage(),
          arguments: {'img': images, 'result': result});
    }
  }

  Widget getImageButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 100,
            width: 100,
            child: RawMaterialButton(
              onPressed: () {
                getImage();
              },
              elevation: 0.0,
              fillColor: ColorStyles.mainGreen,
              padding: const EdgeInsets.all(15.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.image,
                size: 70,
                color: Colors.white,
              ),
            )),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: const Text("이미지로 추가하기", style: TextStyle(fontSize: 20)),
              ),
            ])),
      ],
    );
  }

  Widget getInputButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 100,
            width: 100,
            child: RawMaterialButton(
              onPressed: () {
                Get.to(() => const InputPage());
              },
              elevation: 0.0,
              focusElevation: 0.0,
              fillColor: ColorStyles.mainGreen,
              padding: const EdgeInsets.all(15.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.edit_note,
                size: 70,
                color: Colors.white,
              ),
            )),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: const Text("정산내용 입력하기", style: TextStyle(fontSize: 20)),
              ),
            ])),
      ],
    );
  }
}
