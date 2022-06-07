import 'package:dating/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: ColorConstant.themeScaffold.withOpacity(0.8),
        child: const SpinKitCircle(
          color: ColorConstant.pink,
          size: 42,
        ),
      ),
    );
  }
}
