// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'dart:ui';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/default_screen/liked_by_other_default_screen.dart';
import 'package:dating/screen/home_module/profile_screen/other_user_profile.dart';
import 'package:dating/screen/like_reject_screen/liked_by_other_screen/like_by_others_screen_view_model.dart';
import 'package:dating/screen/match_screen/match_screen.dart';
import 'package:dating/screen/premium_screen/payment_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LikedByOtherScreen extends StatefulWidget {
  const LikedByOtherScreen({Key? key}) : super(key: key);

  @override
  State<LikedByOtherScreen> createState() => LikedByOtherScreenState();
}

class LikedByOtherScreenState extends State<LikedByOtherScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  UserService userService = UserService();
  LikeByOthersScreenViewModel? likeByOthersScreenViewModel;
  bool showAnimation = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    likeByOthersScreenViewModel ??
        (likeByOthersScreenViewModel = LikeByOthersScreenViewModel(this));
    return Consumer2<AppProvider, UserProfileProvider>(
      builder: (context, appProvider, userProfileProvider, _) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                buildBackgroundView(),
                // if (likeByOthersScreenViewModel!.likedByOtherList.isEmpty && !isLoading)
                //   buildAppBarView(appProvider, userProfileProvider),
                likeByOthersScreenViewModel!.likedByOtherList.isEmpty
                    ? const LikedByOthersDefaultScreen()
                    : Column(
                        children: [
                          buildAppBarView(appProvider, userProfileProvider),
                          const SizedBox(height: 4),
                          likeByOthersScreenViewModel!.likedByOtherList.isEmpty
                              ? buildNoUsersView()
                              : buildCardView(userProfileProvider),
                        ],
                      ),
                showAnimation
                    ? Lottie.asset(
                        'assets/animations/heart_rain.json',
                        controller: animationController,
                        // onLoaded: (composition) => animationController!
                        //   ..duration = composition.duration,
                      )
                    : const SizedBox(),
                if (isLoading) const AppLoader()
              ],
            ),
          ),
        );
      },
    );
  }

  Expanded buildCardView(UserProfileProvider userProfileProvider) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20)
            .copyWith(top: 30, bottom: 20),
        physics: const BouncingScrollPhysics(),
        primary: true,
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: List.generate(
            // likeByOthersScreenViewModel!.likedByOtherList.length <= 12
            //     ?
            likeByOthersScreenViewModel!.likedByOtherList.length,
            // : 12,
            (index) {
              UserModel userModel =
                  likeByOthersScreenViewModel!.likedByOtherList[index];
              if (index == 1) {
                return const SizedBox(height: 100);
              }
              return GestureDetector(
                onTap: !userProfileProvider.currentUserData!.isPremiumUser
                    ? () => getPremiumScreen()
                    : () => getProfileInfo(userModel),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ImageFiltered(
                          imageFilter: !userProfileProvider
                                  .currentUserData!.isPremiumUser
                              ? ImageFilter.blur(sigmaX: 10.0, sigmaY: 15.0)
                              : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                          child: AppImageAsset(
                            image: userModel.photos![0],
                            isWebImage: true,
                            webHeight: 250,
                            webWidth: 200,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: userProfileProvider
                                      .currentUserData!.isPremiumUser
                                  ? userModel.userName
                                  : userModel.userName!.substring(0, 3),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            if (userModel.cast != null &&
                                userModel.religion != null)
                              AppText(
                                text:
                                    '${userModel.cast} . ${userModel.religion}',
                                fontSize: 14,
                              ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => cancelUser(
                                      userProfileProvider, userModel, index),
                                  child: const AppImageAsset(
                                    image: ImageConstant.yellowCloseIcon,
                                    height: 34,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: !userProfileProvider
                                          .currentUserData!.isPremiumUser
                                      ? null
                                      : () async {
                                          await userService.removeLikeByMe(
                                            context,
                                            currentUserId: userProfileProvider
                                                .currentUserId,
                                            likedByMe: userModel.userId,
                                          );
                                          animationController!
                                            ..duration =
                                                const Duration(seconds: 2)
                                            ..forward();
                                          setState(() {
                                            showAnimation = true;
                                          });
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            showAnimation = false;
                                            animationController!.reset();
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MatchScreen(
                                                  userModel: userModel,
                                                ),
                                              ),
                                              (route) => false,
                                            );
                                          });
                                        },
                                  child: const AppImageAsset(
                                    image: ImageConstant.likeUserIcon,
                                    height: 34,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container buildAppBarView(
      AppProvider appProvider, UserProfileProvider userProfileProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: ColorConstant.pink,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppImageAsset(
            image: ImageConstant.whiteHeartIcon,
            width: 34,
          ),
          const SizedBox(height: 10),
          const AppText(
            text: 'See who liked you',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          const SizedBox(height: 10),
          if (!userProfileProvider.currentUserData!.isPremiumUser)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: AppText(
                text: 'Upgrade to Rowdy baby premium to see the people who have already SWIPED RIGHT on you',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                maxLines: 4,
                textAlign: TextAlign.center,
              ),
            ),
          if (!userProfileProvider.currentUserData!.isPremiumUser)
            const SizedBox(height: 20),
          if (!userProfileProvider.currentUserData!.isPremiumUser)
            AppElevatedButton(
              text: 'Upgrade to Premium',
              fontSize: 14,
              buttonColor: ColorConstant.yellow,
              height: 46,
              width: 200,
              margin: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  AppImageAsset buildBackgroundView() {
    return const AppImageAsset(
      image: ImageConstant.heartFullBack,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Expanded buildNoUsersView() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        transformAlignment: Alignment.center,
        child: const AppText(
          text: 'If your rowdy likes you you can see here. keep swiping',
          fontColor: ColorConstant.pink,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void getProfileInfo(UserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfile(userModel: userModel),
      ),
    );
  }

  void getPremiumScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
  }

  void cancelUser(
      UserProfileProvider userProfileProvider, UserModel userModel, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppText(
                text: 'Remove user',
                fontSize: 18,
                fontColor: ColorConstant.pink,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const AppText(
                text: 'Are you sure you want to remove your baby',
                fontSize: 14,
                fontColor: ColorConstant.black,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      Navigator.pop(context);
                      await userService.rejectedByMe(
                        context,
                        currentUserId: userProfileProvider.currentUserId,
                        likedByMe: userModel.userId,
                      );
                      await userService.removeLikeByMe(
                        context,
                        currentUserId: userProfileProvider.currentUserId,
                        likedByMe: userModel.userId,
                      );
                      await likeByOthersScreenViewModel!.getUsers();
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16),
                      decoration: BoxDecoration(
                        color: ColorConstant.darkPink,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        text: 'yes'.toUpperCase(),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16),
                      decoration: BoxDecoration(
                        color: ColorConstant.yellow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        text: 'no'.toUpperCase(),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
