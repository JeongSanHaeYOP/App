# **정산해욥(JeongSanHaeYOP)**


OCR로 출금 내역을 스캔하고 원하는 내역만 계산할 수 있도록 하는 앱 서비스


## Features

- Main Feature: OCR로 출금 내역을 인식하고 체크박스로 선택
- Additional Feature: 정산 내역을 공유

<p align="center">
<img src = "https://user-images.githubusercontent.com/65584699/230774943-c88da121-cd1d-4e31-80f5-c912c4143e02.png" width="39%"> <img src = "https://user-images.githubusercontent.com/65584699/230774954-ec3af293-bfd9-4e11-a2e8-7b81fa25aa57.png" width="39%">
</p>

**Main**|**Image Pick**
-----|-----
<img src = "https://user-images.githubusercontent.com/65584699/230775084-6f41fe59-e599-4d45-9a13-866bbb3a731c.png" width="100%">|<img src = "https://user-images.githubusercontent.com/65584699/230775190-8541ead7-220a-4f57-ad25-4b07a92b837e.png" width="100%">
직접 입력, 이미지 입력을 선택하여 진행할 수 있습니다|이미지로 추가하기를 선택하면, 사진을 마음대로 고를 수 있습니다.

**Image Crop**|**Select Content**
-----|-----
<img src = "https://user-images.githubusercontent.com/65584699/230775199-dbb29db3-a932-4db0-88ef-cc56674e27c7.png" width="100%">|<img src = "https://user-images.githubusercontent.com/65584699/230775215-1769c268-c91c-45a5-a2b7-254aefad5d21.png" width="100%">
선택한 사진들을 각각 크롭할 수 있습니다.|사진을 업로드 하시면 OCR로 글자를 인식합니다. 사진을 보면서 정산할 내역을 선택할 수 있습니다. 슬라이드 하면 사진을 여러장 볼 수 있습니다. 따로 내역을 추가할 수 있습니다.

**Type Content**|**Select people and accounts**
-----|-----
<img src = "https://user-images.githubusercontent.com/65584699/230775154-57cfd817-f466-4e46-aeda-6268f27003bf.png" width="100%">|<img src = "https://user-images.githubusercontent.com/65584699/230775171-dc98ba93-6bf7-4fe9-882a-f46bf86ccdc6.png" width="100%">
정산 내용 입력하기를 선택하면, 텍스트로 입력하여 추가할 수 있습니다.|(공통) 정산 인원을 선택할 수 있습니다. 계좌 포함 여부도 선택가능합니다. 계좌는 최종 영수증에 포함됩니다.

**Result**|**Button Custom**
-----|-----
<img src = "https://user-images.githubusercontent.com/65584699/230775182-f1a017c7-414f-4eac-bc7d-25ed151f04e3.png" width="500%">|<img src = "https://user-images.githubusercontent.com/65584699/230775253-d0df1793-2eff-485b-a8c7-d1313c7bea4b.png" width="100%">
선택한 내용으로 영수증이 만들어집니다. 사진을 저장할 수 있으며 공유를 통해 메시지나 메신저로 영수증을 전송할 수 있습니다.|버튼 커스텀을 통해 Android, IOS의 통일성을 주었습니다.


## OCR
Use OCR API : <https://ocr.space>


## Tech Stack

|App|![Flutter](https://img.shields.io/badge/Flutter-02569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2.svg?style=for-the-badge&logo=Dart&logoColor=white)|
|:------:|:---:|



## **Initialization**
- clone the repository

```bash
$ git clone https://github.com/JeongSanHaeYOP/App.git
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


