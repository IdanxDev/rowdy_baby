// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'dart:io';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/about_us_screen/about_us_screen.dart';
import 'package:dating/screen/home_module/profile_screen/edit_profile_screen.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/like_reject_screen/like_reject_screen.dart';
import 'package:dating/screen/need_help_screen/need_help_screen.dart';
import 'package:dating/screen/premium_member_screen/premium_member_screen.dart';
import 'package:dating/screen/premium_screen/payment_screen.dart';
import 'package:dating/screen/verification_status_screen/rejected_screen.dart';
import 'package:dating/screen/verification_status_screen/verified_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_bottom_sheet.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  UserService userService = UserService();
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer<HomeProvider>(
      builder: (context, HomeProvider homeProvider, _) {
        return Consumer<UserProfileProvider>(
          builder: (context, UserProfileProvider userProfileProvider, _) {
            return Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      if (!userProfileProvider.isLoading)
                        buildProfileView(userProfileProvider),
                      Expanded(
                        child: ListView(
                          primary: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 30),
                          children: [
                            GestureDetector(
                              onTap: () => getVerified(userProfileProvider),
                              child: buildProfileCard(
                                ImageConstant.yellowVerifyIcon,
                                'Get verified',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => checkPremium(userProfileProvider),
                              child: buildProfileCard(
                                ImageConstant.yellowWalletIcon,
                                'Premium',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => showMessage(context,
                                  message: 'We are working on it.!',
                                  isError: true),
                              child: buildProfileCard(
                                ImageConstant.yellowShareIcon,
                                'Refer a friend',
                              ),
                            ),
                            GestureDetector(
                              onTap: aboutUs,
                              child: buildProfileCard(
                                ImageConstant.yellowHeartsIcon,
                                'About us',
                              ),
                            ),
                            GestureDetector(
                              onTap: needHelp,
                              child: buildProfileCard(
                                ImageConstant.yellowQuestionIcon,
                                'Need help',
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: ColorConstant.hintColor,
                              thickness: 2,
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => likeRejectScreen(0),
                              child: buildProfileCard(
                                ImageConstant.likeUserIcon,
                                'Liked by you',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => likeRejectScreen(1),
                              child: buildProfileCard(
                                ImageConstant.yellowCancelIcon,
                                'Rejected by you',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => likedByScreen(2),
                              child: buildProfileCard(
                                ImageConstant.colorLikeTab,
                                'See who liked you',
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                  userProfileProvider.isLoading
                      ? const AppLoader()
                      : const SizedBox(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Container buildProfileCard(String profileCardImage, String profileCardName) {
    return Container(
      color: ColorConstant.transparent,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: AppImageAsset(
              image: profileCardImage,
              height: 26,
            ),
          ),
          const SizedBox(width: 20),
          AppText(
            text: profileCardName,
            fontSize: 18,
            fontColor: ColorConstant.black,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Container buildProfileView(UserProfileProvider userProfileProvider) {
    num profilePer = userProfileProvider.currentUserProfile!.profilePercentage!;
    return Container(
      decoration: const BoxDecoration(
        color: ColorConstant.pink,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CircularStepProgressIndicator(
                    totalSteps: 121,
                    currentStep: profilePer.toInt(),
                    circularDirection: CircularDirection.clockwise,
                    stepSize: 4,
                    padding: 0,
                    height: 150,
                    width: 150,
                    roundedCap: (_, __) => true,
                    selectedColor: ColorConstant.lightYellow,
                    unselectedColor: ColorConstant.hintColor,
                    startingAngle: 9.88,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: AppImageAsset(
                        image: userProfileProvider.currentUserData!.photos![0],
                        isWebImage: true,
                        webFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: Colors.black)
                    color: ColorConstant.lightYellow,
                  ),
                  child: AppText(text: '$profilePer%'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: userProfileProvider.currentUserData!.userName!
                    .toTitleCase(),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(width: 10),
              if (userProfileProvider.currentUserData!.isVerified)
                const AppImageAsset(
                  image: ImageConstant.blueVerifyBadge,
                  height: 18,
                )
            ],
          ),
          if (userProfileProvider.currentUserData!.cast != null &&
              userProfileProvider.currentUserData!.religion != null)
            const SizedBox(height: 10),
          if (userProfileProvider.currentUserData!.cast != null &&
              userProfileProvider.currentUserData!.religion != null)
            AppText(
              text:
                  '${userProfileProvider.currentUserData!.cast} . ${userProfileProvider.currentUserData!.religion}',
              fontSize: 18,
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void aboutUs() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
    );
  }

  void needHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NeedHelpScreen()),
    );
  }

  Future<void> getVerified(UserProfileProvider userProfileProvider) async {
    await userProfileProvider.getCurrentUserData(context);
    if (userProfileProvider.currentUserData!.isVerificationApplied != null) {
      if (userProfileProvider.currentUserData!.isVerificationApplied!.toLowerCase() == 'applied') {
        showMessage(context, message: 'We already received your selfie, You may get verified soon.!');
      } else if (userProfileProvider.currentUserData!.isVerificationApplied!.toLowerCase() == 'rejected') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RejectedScreen()),
        );
      } else if (userProfileProvider.currentUserData!.isVerificationApplied!.toLowerCase() == 'verified') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerifiedScreen()),
        );
      }
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => AppBottomSheet(
            buildBottomView: buildBottomSheet(context, userProfileProvider.currentUserId),
          ),
        ),
      );
    }
  }

  Expanded buildBottomSheet(BuildContext context, String? currentUserId) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.only(top: 40, left: 35, right: 25),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.grey),
          color: ColorConstant.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  buildSheetAppBar(context),
                  const SizedBox(height: 20),
                  const AppText(
                    text: 'Add more trusted and believed to your profile',
                    fontSize: 16,
                    fontColor: ColorConstant.black,
                    fontWeight: FontWeight.w500,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  const AppText(
                    text:
                        'Open your camera and take a selfie. we\'ll match it with your profile photos and give your profile a blue verified tick. you selfie will not be displayed on your profile',
                    fontSize: 14,
                    fontColor: ColorConstant.grey,
                    fontWeight: FontWeight.w500,
                    maxLines: 6,
                  ),
                ],
              ),
            ),
            AppElevatedButton(
              text: 'Get verified',
              fontSize: 18,
              margin: 0,
              height: 50,
              onPressed: () => getVerificationSelfie(currentUserId),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  GestureDetector buildSheetAppBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: const BoxDecoration(color: ColorConstant.transparent),
        child: Row(
          children: const [
            AppText(
              text: 'Get Verified',
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            SizedBox(width: 10),
            AppImageAsset(
              image: ImageConstant.blueVerifyBadge,
              height: 20,
              width: 20,
            )
          ],
        ),
      ),
    );
  }

  void likeRejectScreen(int likeType) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.selectedLikeType = likeType;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LikeRejectScreen(),
      ),
    );
  }

  void likedByScreen(int likeType) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.selectedLikeType = likeType;
    appProvider.bottomNavBarIndex = 2;
    appProvider.notifyListeners();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(selectedIndex: 2),
      ),
    );
  }

  void checkPremium(UserProfileProvider userProfileProvider) {
    // if (userProfileProvider.currentUserData!.isPremiumUser) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const PremiumMemberScreen()),
    //   );
    // } else {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => const PaymentScreen(),
      ),
    );
    // }
  }

  Future<void> getVerificationSelfie(String? currentUserId) async {
    PermissionStatus status = await Permission.camera.status;
    if (status == PermissionStatus.granted) {
      XFile? cameraImage = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 100);
      if (cameraImage != null) {
        Reference reference = FirebaseStorage.instance
            .ref('VerificationImages/${DateTime.now().toIso8601String()}');
        try {
          UploadTask uploadTask = reference.putFile(
            File(cameraImage.path),
            SettableMetadata(
                contentType: 'image/${cameraImage.path.split('.').last}'),
          );
          uploadTask.snapshotEvents.listen((event) {
            logs('uploadTask --> ${event.state.name}');
            double value = (event.bytesTransferred / event.totalBytes);
            logs('value --> $value');
          });
          uploadTask.whenComplete(() async {
            String imageUrl = await reference.getDownloadURL();
            logs('Camera images --> $imageUrl');
          });
        } on FirebaseException catch (e) {
          logs('${e.code} : ${e.message} due to ${e.stackTrace}');
        }
        Navigator.pop(context);
        userService.updateProfile(context,
            currentUserId: currentUserId,
            key: 'isVerificationApplied',
            value: 'applied');
        showMessage(
          context,
          message: 'We received your selfie, You may get verified soon.!',
        );
      }
    } else {
      showMessage(context, message: 'Please enable camera permission', isError: true);
      Future.delayed(const Duration(milliseconds: 500),() => openAppSettings(),);
    }
  }
}
