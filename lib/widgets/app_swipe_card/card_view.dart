import 'package:dating/constant/image_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_swipe_card/card_buttons.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class CardView extends StatelessWidget {
  final String? assetPath;
  final SwipableStackController? swipableStackController;

  const CardView({
    @required this.assetPath,
    @required this.swipableStackController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: AppImageAsset(
            image: assetPath!,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(26),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black12.withOpacity(0),
                  Colors.black12.withOpacity(.4),
                  Colors.black12.withOpacity(.82),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      AppText(
                        text: 'Priyanka',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(width: 10),
                      AppImageAsset(
                        image: ImageConstant.verifyBadge,
                        height: 18,
                      )
                    ],
                  ),
                  const AppText(
                    text: 'Chowdary . Hindu . Hyderabad',
                    fontSize: 18,
                  ),
                  const SizedBox(height: CardButton.height + 30),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
        CardButton(
          kmValue: 5,
          onSwipe: (swipeDirection) {
            swipableStackController!.next(swipeDirection: swipeDirection);
          },
        ),
      ],
    );
  }
}
