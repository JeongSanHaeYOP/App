import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_jshy/selectpage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:multi_crop_picker/picker.dart';
// import 'package:multi_image_crop/multi_image_crop.dart';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

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
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            SizedBox(
                height: 100,
                width: 100,
                child: RawMaterialButton(
                  onPressed: () {
                    getImage();
                  },
                  elevation: 2.0,
                  fillColor: const Color(0xff7FB77E),
                  padding: const EdgeInsets.all(15.0),
                  shape: CircleBorder(),
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
                        child: const Text("정산할 금액이 들어간",
                            style: TextStyle(fontSize: 20)),
                      ),
                      const Text("이미지를 선택해 주세요.",
                          style: TextStyle(fontSize: 20)),
                    ]
                )
            ),
            TextButton(
                onPressed: cropImage,
                child: Text("crop")
            ),
            TextButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectPage()));
                },
                child: Text('next')
            ),
          ]
      ),
    );
  }

  XFile? _image;
  CroppedFile? _croppedImage;
  Future getImage() async {
    // for gallery
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image!;
    });
    if(_image != null) {
      cropImage();
    }
  }

  Future<void> cropImage() async {
    if (_image != null) {
      var croppedImage = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: const Color(0xff7FB77E),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
          IOSUiSettings(
            title: '',
          ),],
      );
      if (croppedImage != null) {
        setState(() {
          _croppedImage = croppedImage;
        });
      }
      // final Directory dir = await getApplicationDocumentsDirectory();
      // final String appDir = dir.path;
      //
      // final File imageFile = File('$appDir/profile_picture.jpg');
      // if (await imageFile.exists()) {
      //   imageFile.delete();
      // }
      //
      // imageCache.clearLiveImages();
      // imageCache.clear();
      //
      // final File copiedImage = await _croppedImage.copy('$appDir/profile_picture.jpg');
      // File myImage = File(copiedImage.path);
      final File imageFile = File(croppedImage!.path);


      if(_croppedImage != null) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectPage(imageFile)));
        // print(imageFile);
        nextPage(imageFile);
      }
    }
  }

  void nextPage(img) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectPage(img)));
  }

  // Future<void> getCroppedImagePath() async {
  //   final Directory dir = await getApplicationDocumentsDirectory();
  //   final String appDir = dir.path;
  //
  //   final File imageFile = File('$appDir/profile_picture.jpg');
  //   if (await imageFile.exists()) {
  //     imageFile.delete();
  //   }
  //
  //   imageCache.clearLiveImages();
  //   imageCache.clear();
  //
  //   final File copiedImage = await _croppedImage?.copy('$appDir/profile_picture.jpg');
  //
  // }


}



