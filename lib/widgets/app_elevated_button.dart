import 'package:dating/constant/color_constant.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final double? height;
  final double width;
  final double margin;
  final double textSize;
  final double borderRadius;
  final String? text;
  final Color textColor;
  final FontWeight? fontWeight;
  final Color buttonColor;
  final VoidCallback? onPressed;
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;

  const AppElevatedButton({
    Key? key,
    this.height,
    this.width = double.infinity,
    this.margin = 30,
    this.textSize = 20,
    this.borderRadius = 8,
    this.text,
    this.textColor = ColorConstant.white,
    this.buttonColor = ColorConstant.pink,
    this.onPressed,
    this.fontWeight,
    this.padding,
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
        child: AppText(
          text: text,
          fontSize: textSize,
          fontColor: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
