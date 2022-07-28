// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/premium_screen/premium_bottom_sheet.dart';
import 'package:dating/service/rest_service.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_bottom_sheet.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_photo_viewer.dart';
import 'package:dating/widgets/app_swipe_card/card_overlay.dart';
import 'package:dating/widgets/app_swipe_card/card_view.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({Key? key}) : super(key: key);

  @override
  State<SwipeScreen> createState() => SwipeScreenState();
}

class SwipeScreenState extends State<SwipeScreen> {
  int secondsRemaining = 40;
  Timer? timer;
  UserService userService = UserService();
  final ScrollController scrollController = ScrollController();
  EdgeInsetsGeometry cardMargin = const EdgeInsets.only(right: 12, left: 20);
  final SwipableStackController swipableStackController =
      SwipableStackController();

  @override
  initState() {
    super.initState();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.getAllUsers(context, isSwipe: true);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          homeProvider.isDetails = false;
          homeProvider.notifyListeners();
        }
      }
    });
    getTimer();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, _) {
        if (homeProvider.isCardCompleted ||
            homeProvider.userModelList!.isEmpty) {}
        // homeProvider.getAllUsers(context);
        return Consumer<UserProfileProvider>(
          builder: (context, UserProfileProvider userProfileProvider, _) {
            return Scaffold(
              body: homeProvider.isLoading
                  ? const AppLoader()
                  : homeProvider.isDetails
                      ? buildProfileDetailView(
                          context,
                          homeProvider,
                          swipableStackController.currentIndex,
                          userProfileProvider)
                      : homeProvider.isCardCompleted
                          ? buildRippleCardView(context, userProfileProvider)
                          : buildSwipableCard(
                              context, homeProvider, userProfileProvider),
            );
          },
        );
      },
    );
  }

  Container buildSwipableCard(BuildContext context, HomeProvider homeProvider,
      UserProfileProvider userProfileProvider) {
    return homeProvider.userModelList!.isEmpty
        ? buildRippleCardView(context, userProfileProvider)
        : Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            decoration: const BoxDecoration(color: ColorConstant.white),
            child: SwipableStack(
              detectableSwipeDirections: const {
                SwipeDirection.right,
                SwipeDirection.left,
              },
              controller: swipableStackController,
              onSwipeCompleted: (index, direction) {
                if (index == homeProvider.userModelList!.length - 1) {
                  homeProvider.isCardCompleted = true;
                  homeProvider.notifyListeners();
                }
                if (direction == SwipeDirection.right) {
                  userService.likeByMe(
                    context,
                    currentUserId: userProfileProvider.currentUserId,
                    likedByMe: homeProvider.userModelList![index].userId,
                  );
                  RestServices.sendNotificationRestCall(
                    context,
                    message: 'Tap to see',
                    title: 'You have got new request from ${userProfileProvider.currentUserData!.userName}',
                    // token: userProfileProvider.currentUserData!.fcmToken,
                    token: homeProvider.userModelList![index].fcmToken,
                  );
                }
                if (direction == SwipeDirection.left) {
                  userService.rejectedByMe(
                    context,
                    currentUserId: userProfileProvider.currentUserId,
                    likedByMe: homeProvider.userModelList![index].userId,
                  );
                }
                userService.swipedByMe(
                  context,
                  currentUserId: userProfileProvider.currentUserId,
                  swipedByMe: homeProvider.userModelList![index].userId,
                );
              },
              itemCount: homeProvider.userModelList!.length,
              horizontalSwipeThreshold: 1,
              swipeAssistDuration: const Duration(seconds: 2),
              onWillMoveNext: (index, direction) {
                if (index >= 15 &&
                    !userProfileProvider.currentUserData!.isPremiumUser) {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, _, __) =>
                          const PremiumBottomSheet(),
                    ),
                  );
                  return false;
                }
                return true;
              },
              builder: (context, properties) {
                // final itemIndex = properties.index % images.length;
                return Stack(
                  children: [
                    CardView(
                      userData: homeProvider.userModelList![properties.index],
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
          );
  }

  Container buildRippleCardView(
      BuildContext context, UserProfileProvider userProfileProvider) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          FlutterRipple(
            radius: 140,
            rippleColor: ColorConstant.pink,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: ColorConstant.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: AppImageAsset(
                  image: (userProfileProvider.currentUserData!.photos == null ||
                          userProfileProvider.currentUserData!.photos!.isEmpty)
                      ? ''
                      : userProfileProvider.currentUserData!.photos![0],
                  isWebImage: true,
                  webHeight: double.infinity,
                  webWidth: double.infinity,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 2.3),
                AppText(
                  text: secondsRemaining == 0
                      ? 'Please try to change filters and get best filters'
                      : 'Searching for your baby near you...',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  maxLines: 3,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // if (secondsRemaining != 0)
                const AppText(
                  text: 'Keep change your filter to get better results',
                  fontColor: ColorConstant.grey,
                  fontSize: 14,
                  maxLines: 3,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildProfileDetailView(
      BuildContext context,
      HomeProvider homeProvider,
      int index,
      UserProfileProvider userProfileProvider) {
    UserModel userModel = homeProvider.userModelList![index];
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          swipableStackController.next(swipeDirection: SwipeDirection.right);
        }
        if (details.delta.dx < 0) {
          swipableStackController.next(swipeDirection: SwipeDirection.left);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
              Hero(
                tag: homeProvider
                    .userModelList![swipableStackController.currentIndex].userId
                    .toString(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: AppImageAsset(
                    image: homeProvider
                        .userModelList![swipableStackController.currentIndex]
                        .photos![0],
                    isWebImage: true,
                    webHeight: MediaQuery.of(context).size.height / 1.3,
                    webWidth: MediaQuery.of(context).size.width,
                    webFit: BoxFit.cover,
                  ),
                ),
              ),
              if (userModel.aboutMe != null && userModel.aboutMe!.isNotEmpty)
                aboutMeView(userModel.aboutMe),
              if (userModel.usageType != null &&
                  userModel.usageType!.isNotEmpty)
                lookingForView(userModel.usageType),
              const SizedBox(height: 20),
              cardTitleText('Personal info'),
              const SizedBox(height: 16),
              buildPersonalInfo(userModel),
              const SizedBox(height: 30),
              CarouselSlider(
                items: List.generate(
                  homeProvider
                      .userModelList![swipableStackController.currentIndex]
                      .photos!
                      .length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              AppPhotoViewer(
                            photoViewerImages: homeProvider
                                .userModelList![
                                    swipableStackController.currentIndex]
                                .photos!,
                            selectedIndex: index,
                          ),
                        ),
                      );
                    },
                    child: AppImageAsset(
                      image: homeProvider
                          .userModelList![swipableStackController.currentIndex]
                          .photos![index],
                      isWebImage: true,
                      webWidth: MediaQuery.of(context).size.width,
                      webHeight: MediaQuery.of(context).size.height / 3.0,
                      webFit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 3.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 1,
                ),
              ),
              buildBottomNavBar(
                  context,
                  homeProvider,
                  homeProvider
                      .userModelList![swipableStackController.currentIndex]
                      .userId,
                  userProfileProvider),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Column lookingForView(String? usageType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        cardTitleText('Looking for'),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: cardMargin,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0XFFE1E1E1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: usageType,
                fontColor: ColorConstant.black,
                fontSize: 16,
                letterSpacing: 0.48,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row buildBottomNavBar(BuildContext context, HomeProvider homeProvider,
      String? userId, UserProfileProvider userProfileProvider) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            homeProvider.isDetails = false;
            homeProvider.notifyListeners();
          },
          child: Container(
            padding: const EdgeInsets.only(top: 34, bottom: 14, left: 26),
            decoration: const BoxDecoration(
              color: ColorConstant.transparent,
            ),
            child: const AppText(
              text: 'Back',
              fontSize: 18,
              fontColor: ColorConstant.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => AppBottomSheet(
                currentIndex: 0,
                title: 'Block & Report',
                sheetData: blockReasonList,
                onPressed: () => blockUser(
                    userId, userProfileProvider.currentUserId, homeProvider),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 34, bottom: 14, right: 26),
            decoration: const BoxDecoration(
              color: ColorConstant.transparent,
            ),
            child: const AppText(
              text: 'Block & Report',
              fontSize: 18,
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Wrap buildPersonalInfo(UserModel userModel) {
    return Wrap(
      spacing: -20,
      runSpacing: 20,
      children: [
        if (userModel.gender != null && userModel.gender!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.genderCardIcon,
            name: userModel.gender,
          ),
        if (userModel.age != null && userModel.age!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.birthdayCardIcon,
            name: dateFormatter(userModel.age),
          ),
        if (userModel.height != null && userModel.height!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.heightCardIcon,
            name: userModel.height,
          ),
        if (userModel.smoke != null && userModel.smoke!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.smokingCard,
            name: userModel.smoke,
          ),
        if (userModel.drink != null && userModel.drink!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.drinkingCard,
            name: userModel.drink,
          ),
        if (userModel.education != null && userModel.education!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.educationCard,
            name: userModel.education,
          ),
        if (userModel.occupation != null && userModel.occupation!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.jobCard,
            name: userModel.occupation,
          ),
        if (userModel.language != null && userModel.language!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.languageCard,
            name: userModel.language!.join(', '),
          ),
      ],
    );
  }

  Container buildPersonalInfoCard(
      {@required String? image, @required String? name}) {
    return Container(
      margin: cardMargin,
      // width: 80,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0XFFE1E1E1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImageAsset(
            image: image,
            height: 16,
          ),
          const SizedBox(width: 8),
          Flexible(
            fit: FlexFit.loose,
            child: AppText(
              text: name,
              fontColor: ColorConstant.black,
              fontSize: 16,
              letterSpacing: 0.48,
              maxLines: 2,
            ),
          ),
        ],
      ),
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

  Column aboutMeView(String? aboutMe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        cardTitleText('About me'),
        const SizedBox(height: 4),
        Padding(
          padding: cardMargin,
          child: AppText(
            text: aboutMe,
            maxLines: 5,
            fontSize: 16,
            fontColor: ColorConstant.black,
          ),
        ),
      ],
    );
  }

  Future<void> blockUser(
      String? userId, String? currentUserId, HomeProvider homeProvider) async {
    await UserService().addBlockList(context,
        currentUserId: currentUserId, blockUserId: userId);
    homeProvider.selectedBlockReason = -1;
    homeProvider.isDetails = false;
    homeProvider.notifyListeners();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const AppText(
          text: 'Block & Report Successfully',
          fontSize: 18,
          fontColor: ColorConstant.pink,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppText(
              text:
                  'They won\'t know that you\'ve blocked or reported of them. Thanks for your feedback',
              fontSize: 14,
              fontColor: ColorConstant.black,
              fontWeight: FontWeight.w400,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(selectedIndex: 1)),
                (route) => false,
              ),
              child: AppText(
                text: 'Okay'.toUpperCase(),
                fontSize: 18,
                fontColor: ColorConstant.pink,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getTimer() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (homeProvider.isCardCompleted || homeProvider.userModelList!.isEmpty) {
        if (secondsRemaining != 0) {
          secondsRemaining--;
        }
      }
      if (mounted && secondsRemaining <= 0) {
        setState(() {});
      }
    });
  }
}
