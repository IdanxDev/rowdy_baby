import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class CardButton extends StatelessWidget {
  final ValueChanged<SwipeDirection>? onSwipe;
  final int? kmValue;

  const CardButton({Key? key, @required this.onSwipe, this.kmValue})
      : super(key: key);

  static const double height = 80;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            const SizedBox(width: 40),
            ElevatedButton(
              onPressed: () => onSwipe!(SwipeDirection.left),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                backgroundColor:
                    MaterialStateProperty.all(ColorConstant.transparent),
                overlayColor: MaterialStateProperty.all(
                    ColorConstant.yellow.withOpacity(0.2)),
                shape: MaterialStateProperty.all(const CircleBorder()),
                minimumSize: MaterialStateProperty.all(const Size.square(20)),
              ),
              child: const AppImageAsset(
                image: ImageConstant.passUserIcon,
                height: 50,
              ),
            ),
            const Spacer(),
            AppText(
              text: '$kmValue km'.toUpperCase(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => onSwipe!(SwipeDirection.right),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                backgroundColor:
                    MaterialStateProperty.all(ColorConstant.transparent),
                overlayColor: MaterialStateProperty.all(
                    ColorConstant.darkPink.withOpacity(0.5)),
                shape: MaterialStateProperty.all(const CircleBorder()),
                minimumSize: MaterialStateProperty.all(const Size.square(20)),
              ),
              child: const AppImageAsset(
                image: ImageConstant.likeUserIcon,
                height: 50,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
