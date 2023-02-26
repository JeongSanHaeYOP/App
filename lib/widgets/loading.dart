import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/colors.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromRGBO(61, 61, 61, 0.5372549019607843),
        child: const Center(
          child: SpinKitFadingCircle(
            color: ColorStyles.mainGreen,
            size: 80.0,
          ),
        ));
  }
}
