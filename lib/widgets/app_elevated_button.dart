import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final double? height;
  final double width;
  final double margin;
  final double fontSize;
  final double borderRadius;
  final String? text;
  final Color fontColor;
  final FontWeight? fontWeight;
  final Color buttonColor;
  final VoidCallback? onPressed;
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;
  final bool showIcon;

  const AppElevatedButton({
    Key? key,
    this.height,
    this.width = double.infinity,
    this.margin = 30,
    this.fontSize = 20,
    this.borderRadius = 8,
    @required this.text,
    this.fontColor = ColorConstant.white,
    this.buttonColor = ColorConstant.pink,
    this.onPressed,
    this.fontWeight,
    this.padding,
    this.showIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: margin),
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: padding,
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          shadowColor: MaterialStateProperty.all(ColorConstant.transparent),
          backgroundColor: MaterialStateProperty.all(buttonColor),
          overlayColor: MaterialStateProperty.all(buttonColor.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon)
              const AppImageAsset(
                image: ImageConstant.logoutIcon,
                height: 20,
              ),
            if (showIcon) const SizedBox(width: 10),
            AppText(
              text: text,
              fontSize: fontSize,
              fontColor: fontColor,
              fontWeight: fontWeight,
            ),
          ],
        ),
      ),
    );
  }
}
