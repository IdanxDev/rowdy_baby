// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/chat_module/conversation_screen/conversation_screen.dart';
import 'package:dating/screen/like_reject_screen/like_reject_screen_view_model.dart';
import 'package:dating/screen/like_reject_screen/liked_by_other_screen/liked_by_other_screen.dart';
import 'package:dating/screen/premium_screen/premium_bottom_sheet.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikeRejectScreen extends StatefulWidget {
  const LikeRejectScreen({Key? key}) : super(key: key);

  @override
  State<LikeRejectScreen> createState() => LikeRejectScreenState();
}

class LikeRejectScreenState extends State<LikeRejectScreen> {
  bool isLoading = true;
  LikeRejectScreenViewModel? likeRejectScreenViewModel;

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    likeRejectScreenViewModel ??
        (likeRejectScreenViewModel = LikeRejectScreenViewModel(this));
    return Consumer2<AppProvider, UserProfileProvider>(
      builder: (context, AppProvider appProvider, userProfileProvider, _) {
        return SafeArea(
          child: appProvider.selectedLikeType == 2
              ? const LikedByOtherScreen()
              : Scaffold(
                  appBar: buildAppBar(context, appProvider),
                  body: Stack(
                    children: [
                      ListView.separated(
                        primary: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        itemCount: appProvider.selectedLikeType == 0
                            ? likeRejectScreenViewModel!.likedByMeList.length
                            : appProvider.selectedLikeType == 1
                                ? likeRejectScreenViewModel!
                                    .rejectedByMeList.length
                                : likeRejectScreenViewModel!
                                    .likedByOtherList.length,
                        itemBuilder: (context, index) {
                          UserModel userModel = appProvider.selectedLikeType ==
                                  0
                              ? likeRejectScreenViewModel!.likedByMeList[index]
                              : appProvider.selectedLikeType == 1
                                  ? likeRejectScreenViewModel!
                                      .rejectedByMeList[index]
                                  : likeRejectScreenViewModel!
                                      .likedByOtherList[index];
                          if (!userModel.isAvailable) {
                            return const SizedBox();
                          }
                          return GestureDetector(
                            onTap: () {
                              goToConversationScreen(
                                  userProfileProvider, userModel);
                            },
                            child: Container(
                              color: ColorConstant.transparent,
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: AppImageAsset(
                                      image: userModel.photos![0],
                                      isWebImage: true,
                                      webHeight: 50,
                                      webWidth: 50,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: userModel.userName!.toTitleCase(),
                                        fontColor: ColorConstant.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      if (userModel.cast != null &&
                                          userModel.religion != null)
                                        const SizedBox(height: 4),
                                      if (userModel.cast != null &&
                                          userModel.religion != null)
                                        AppText(
                                          text:
                                              '${userModel.cast} . ${userModel.religion}',
                                          fontColor: ColorConstant.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const AppImageAsset(
                                    image: ImageConstant.colorChatTab,
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 2,
                            color: ColorConstant.white,
                          );
                        },
                      ),
                      if ((appProvider.selectedLikeType == 0 && likeRejectScreenViewModel!.likedByMeList.isEmpty && !isLoading) ||
                          (appProvider.selectedLikeType == 1 && likeRejectScreenViewModel!.rejectedByMeList.isEmpty && !isLoading))
                        const Align(
                          alignment: Alignment.center,
                          child: AppText(
                            text: 'No data available',
                            fontSize: 16,
                            fontColor: ColorConstant.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      isLoading ? const AppLoader() : const SizedBox(),
                    ],
                  ),
                ),
        );
      },
    );
  }

  PreferredSize buildAppBar(BuildContext context, AppProvider appProvider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height),
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                appProvider.bottomNavBarIndex = 0;
                appProvider.notifyListeners();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                color: ColorConstant.transparent,
                child: const AppImageAsset(image: ImageConstant.circleBackIcon),
              ),
            ),
            AppText(
              text: appProvider.likeType[appProvider.selectedLikeType],
              fontSize: 22,
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  void goToConversationScreen(
      UserProfileProvider userProfileProvider, UserModel userModel) {
    if (!userProfileProvider.currentUserData!.isPremiumUser) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => const PremiumBottomSheet(),
        ),
      );
    } else {
      String chatRoomId = userProfileProvider.currentUserId.hashCode <=
              userModel.userId.hashCode
          ? '${userProfileProvider.currentUserId}-${userModel.userId}'
          : '${userModel.userId}-${userProfileProvider.currentUserId}';
      logs('ChatroomId --> $chatRoomId');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatroomId: chatRoomId,
            userModel: userModel,
          ),
        ),
      );
    }
  }
}
