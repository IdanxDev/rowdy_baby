import 'package:dating/constant/color_constant.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
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
  final EdgeInsetsGeometry? padding;

  const AppOutlinedButton({
    Key? key,
    this.height,
    this.width = double.infinity,
    this.margin = 30,
    this.fontSize = 20,
    this.borderRadius = 8,
    this.text,
    this.fontColor = ColorConstant.yellow,
    this.buttonColor = ColorConstant.white,
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
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstant.yellow, width: 1.6),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(padding),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          shadowColor: MaterialStateProperty.all(ColorConstant.transparent),
          backgroundColor:
              MaterialStateProperty.all(buttonColor.withOpacity(0.2)),
          // overlayColor: MaterialStateProperty.all(buttonColor.withOpacity(0.2)),
        ),
        child: AppText(
          text: text,
          fontSize: fontSize,
          fontColor: fontColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
