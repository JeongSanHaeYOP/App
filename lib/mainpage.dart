import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_jshy/main.dart';
import 'package:frontend_jshy/selectpage.dart';
import 'package:frontend_jshy/theme/colors.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:multi_crop_picker/picker.dart';
// import 'package:multi_image_crop/multi_image_crop.dart';
import 'dart:io';
import 'dart:async';

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
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: getInputButton(),
            ),
            getImageButton(),
          ]
      ),
    );
  }

  // XFile? _image;
  // CroppedFile? _croppedImage;

  late List<XFile?> _imgList;
  final List<CroppedFile?> _croppedImgList = [];


  Future getImage() async {
    // Initialized croppedImageList
    _croppedImgList.clear();
    // for gallery
    var imgList = await ImagePicker().pickMultiImage();
    setState(() {
      _imgList = imgList!;
    });

    if(_imgList.isNotEmpty) {
      cropImage();
    }
  }
  Future<void> cropImage() async {
    if (_imgList.isNotEmpty) {
      // 고른 이미지들 각각 크롭 액티비티 돌리기
      for (int i = 0; i < _imgList.length; i ++) {
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
        if (croppedImage != null) {
          setState(() {
            _croppedImgList.add(croppedImage);
          });
        }
      }

      List<File> imageFileList = [];
      for (int i = 0; i < _croppedImgList.length; i ++) {
        imageFileList.add(File(_croppedImgList[i]!.path));
      }

      if(_croppedImgList.isNotEmpty) {
        nextPage(imageFileList);
      }
    }
  }

  // Future<void> cropImage() async {
  //   if (_image != null) {
  //     var croppedImage = await ImageCropper().cropImage(
  //       sourcePath: _image!.path,
  //       compressFormat: ImageCompressFormat.jpg,
  //       compressQuality: 100,
  //       uiSettings: [
  //         AndroidUiSettings(
  //           toolbarTitle: '',
  //           toolbarColor: const Color(0xff7FB77E),
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //         IOSUiSettings(
  //           title: '',
  //         ),],
  //     );
  //     if (croppedImage != null) {
  //       setState(() {
  //         _croppedImage = croppedImage;
  //       });
  //     }
  //     final File imageFile = File(croppedImage!.path);
  //
  //
  //     if(_croppedImage != null) {
  //       // nextPage(imageFile);
  //     }
  //   }
  // }

  // List<XFile>? pickedFiles = [];
  // List<File> croppedFiles = [];
  // final ImagePicker _picker = ImagePicker();
  //
  // void getImages() async {
  //   pickedFiles = await _picker.pickMultiImage();
  //   MultiImageCrop.startCropping(
  //       context: context,
  //       aspectRatio: 0.5,
  //       activeColor: ColorStyles.mainGreen,
  //       pixelRatio: 2,
  //       files: List.generate(
  //           pickedFiles!.length, (index) => File(pickedFiles![index].path)),
  //       callBack: (List<File> images) {
  //         setState(() {
  //           croppedFiles = images;
  //         });
  //         nextPage(croppedFiles);
  //       });
  // }

  void nextPage(List<File> images) {
    if(images.isEmpty) {
      Get.to(() => const MainPage());
      print("------------Empty");
    } else {
      Get.to(() => const SelectPage(), arguments: images);
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
            )
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
                children: <Widget> [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: const Text("이미지로 추가하기",
                        style: TextStyle(fontSize: 20)),
                  ),
                ]
            )
        ),
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
            )
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
                children: <Widget> [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: const Text("정산내용 입력하기",
                        style: TextStyle(fontSize: 20)),
                  ),
                ]
            )
        ),
      ],
    );
  }


}



