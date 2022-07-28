import 'package:dating/constant/color_constant.dart';
import 'package:dating/widgets/app_text.dart';
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

class AppImageLoader extends StatelessWidget {
  final String loadingText;

  const AppImageLoader(
      {Key? key, this.loadingText = 'Please wait, Uploading image!'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: ColorConstant.themeScaffold.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            text: loadingText,
            fontSize: 20,
            fontColor: ColorConstant.pink,
            fontWeight: FontWeight.bold,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const SpinKitRipple(
            color: ColorConstant.pink,
            size: 62,
          )
        ],
      ),
    );
  }
}
