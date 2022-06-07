// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_swipe_card/card_overlay.dart';
import 'package:dating/widgets/app_swipe_card/card_view.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({Key? key}) : super(key: key);

  @override
  State<SwipeScreen> createState() => SwipeScreenState();
}

class SwipeScreenState extends State<SwipeScreen> {
  final ScrollController scrollController = ScrollController();
  EdgeInsetsGeometry cardMargin = const EdgeInsets.only(right: 12, left: 20);
  final SwipableStackController swipableStackController =
      SwipableStackController();
  List<String> images = [
    ImageConstant.slider1,
    ImageConstant.slider2,
    ImageConstant.slider3
  ];

  @override
  initState() {
    super.initState();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          homeProvider.isDetails = false;
          homeProvider.notifyListeners();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, _) {
        return Scaffold(
          body: homeProvider.isDetails
              ? GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dx > 0) {
                      swipableStackController.next(
                          swipeDirection: SwipeDirection.right);
                    }
                    if (details.delta.dx < 0) {
                      swipableStackController.next(
                          swipeDirection: SwipeDirection.left);
                    }
                    homeProvider.isDetails = false;
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0XFFF2F2F2),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: ListView(
                        shrinkWrap: true,
                        controller: scrollController,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const SizedBox(height: 20),
                          cardTitleText('About me'),
                          const SizedBox(height: 4),
                          Padding(
                            padding: cardMargin,
                            child: const AppText(
                              text:
                                  'Hey, new to the city sip if you wanna explore the unexplored parts of the city! Irony is I\'m trying to find friends on rowdy baby',
                              maxLines: 5,
                              fontSize: 16,
                              fontColor: ColorConstant.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          cardTitleText('Looking for'),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: cardMargin,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0XFFE1E1E1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const AppText(
                                  text: 'Relationship/date',
                                  fontColor: ColorConstant.black,
                                  fontSize: 16,
                                  letterSpacing: 0.48,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          cardTitleText('Personal info'),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: -20,
                            runSpacing: 20,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: cardMargin,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        AppImageAsset(
                                          image: ImageConstant.genderCardIcon,
                                          height: 16,
                                        ),
                                        SizedBox(width: 8),
                                        AppText(
                                          text: 'Male',
                                          fontColor: ColorConstant.black,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: cardMargin,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        AppImageAsset(
                                          image: ImageConstant.birthdayCardIcon,
                                          height: 16,
                                        ),
                                        SizedBox(width: 4),
                                        AppText(
                                          text: '19-05-1995',
                                          fontColor: ColorConstant.black,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: cardMargin,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        AppImageAsset(
                                          image: ImageConstant.heightCardIcon,
                                          height: 16,
                                        ),
                                        SizedBox(width: 10),
                                        AppText(
                                          text: '5\'6"',
                                          fontColor: ColorConstant.black,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: cardMargin,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        AppImageAsset(
                                          image: ImageConstant.smokingCard,
                                          height: 16,
                                        ),
                                        SizedBox(width: 10),
                                        AppText(
                                          text: 'Yes',
                                          fontColor: ColorConstant.black,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: cardMargin,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        AppImageAsset(
                                          image: ImageConstant.drinkingCard,
                                          height: 16,
                                        ),
                                        SizedBox(width: 10),
                                        AppText(
                                          text: 'No',
                                          fontColor: ColorConstant.black,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: cardMargin,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        AppImageAsset(
                                          image: ImageConstant.educationCard,
                                          height: 16,
                                        ),
                                        SizedBox(width: 10),
                                        AppText(
                                          text: 'Graduate',
                                          fontColor: ColorConstant.black,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: cardMargin,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        AppImageAsset(
                                          image: ImageConstant.jobCard,
                                          height: 16,
                                        ),
                                        SizedBox(width: 10),
                                        AppText(
                                          text: 'Software Engineer',
                                          fontColor: ColorConstant.black,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: cardMargin,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        AppImageAsset(
                                          image: ImageConstant.languageCard,
                                          height: 16,
                                        ),
                                        SizedBox(width: 10),
                                        AppText(
                                          text: 'Telugu, Hindi, English',
                                          fontColor: ColorConstant.black,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          AppImageAsset(
                            image: images[swipableStackController.currentIndex],
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3.0,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.center,
                            child: AppText(
                              text: 'Block & Report',
                              fontSize: 18,
                              fontColor: ColorConstant.pink,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy <= 0) {
                      homeProvider.isDetails = true;
                      homeProvider.notifyListeners();
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 10),
                    child: SwipableStack(
                      detectableSwipeDirections: const {
                        SwipeDirection.right,
                        SwipeDirection.left,
                      },
                      controller: swipableStackController,
                      onSwipeCompleted: (index, direction) {
                        logs('onSwipeCompleted --> $index, $direction');
                      },
                      // itemCount: images.length,
                      horizontalSwipeThreshold: 1,
                      swipeAssistDuration: const Duration(seconds: 2),
                      builder: (context, properties) {
                        final itemIndex = properties.index % images.length;
                        return Stack(
                          children: [
                            CardView(
                              assetPath: images[itemIndex],
                              swipableStackController: swipableStackController,
                            ),
                            if (properties.stackIndex == 0 &&
                                properties.direction != null)
                              CardOverlay(
                                swipeProgress: properties.swipeProgress,
                                direction: properties.direction!,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }

  Padding cardTitleText(String cardTitle) {
    return Padding(
      padding: cardMargin,
      child: AppText(
        text: cardTitle,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontColor: ColorConstant.pink,
      ),
    );
  }
}
