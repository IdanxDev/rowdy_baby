import 'package:dating/constant/color_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppSocialMediaButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? image;
  final String? text;

  const AppSocialMediaButton({Key? key, this.text, this.onTap, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24)
            .copyWith(right: 0),
        margin: const EdgeInsets.only(right: 42, left: 10),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppImageAsset(
              image: image,
              height: 30,
            ),
            const SizedBox(width: 20),
            AppText(
              text: text,
              fontSize: 16,
              fontColor: ColorConstant.black,
            )
          ],
        ),
      ),
    );
  }
}
