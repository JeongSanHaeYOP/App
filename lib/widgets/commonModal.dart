import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

Future confirmModal(context, String text) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          backgroundColor: Colors.white,
          title: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 15),
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
                          Navigator.pop(context, false);
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
                          "확인",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        )),
                  ),
                ],
              ),
            )
          ],
        );
      });
}
