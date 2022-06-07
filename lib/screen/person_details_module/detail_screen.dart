import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        AppImageAsset(
          image: ImageConstant.appIcon,
          height: 82,
          width: 104,
        ),
        SizedBox(height: 32),
        AppText(
          text: 'Attractive choices, keep it up',
          fontSize: 34,
          fontColor: ColorConstant.pink,
          fontWeight: FontWeight.bold,
          maxLines: 3,
        ),
        SizedBox(height: 6),
        AppText(
          text: 'your baby need more information like height, smoke, drink etc',
          fontSize: 22,
          fontColor: ColorConstant.black,
          maxLines: 3,
        ),
      ],
    );
  }
}
