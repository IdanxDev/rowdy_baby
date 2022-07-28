// ignore_for_file: use_build_context_synchronously, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/constant/string_constant.dart';
import 'package:dating/provider/disposable_provider/disposable_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/logIn_screen/login_screen.dart';
import 'package:dating/service/auth_service.dart';
import 'package:dating/service/chat_service.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_bottom_sheet.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_outlined_button.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NeedHelpScreen extends StatefulWidget {
  const NeedHelpScreen({Key? key}) : super(key: key);

  @override
  State<NeedHelpScreen> createState() => NeedHelpScreenState();
}

class NeedHelpScreenState extends State<NeedHelpScreen> {
  UserService userService = UserService();
  AuthService authService = AuthService();
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer<UserProfileProvider>(
      builder: (context, UserProfileProvider userProfileProvider, _) {
        return SafeArea(
          child: Scaffold(
            appBar: buildAppBar(context, userProfileProvider),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildContactUsTitle('Account'),
                    if (userProfileProvider
                        .currentUserData!.phoneNumber!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: AppText(
                          text: userProfileProvider.currentUserData!.phoneNumber,
                          fontSize: 20,
                          fontColor: ColorConstant.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (userProfileProvider.currentUserData!.emailAddress != null &&
                        userProfileProvider
                            .currentUserData!.emailAddress!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: AppText(
                          text: userProfileProvider.currentUserData!.emailAddress,
                          fontSize: 20,
                          fontColor: ColorConstant.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    buildContactUsTitle('Contact Us'),
                    buildEmailLauncher(),
                    const Spacer(),
                    AppElevatedButton(
                      text: 'Logout',
                      height: 50,
                      showIcon: true,
                      onPressed: () => logOutTap(),
                    ),
                    const SizedBox(height: 30),
                    AppOutlinedButton(
                      text: 'Delete Account',
                      height: 50,
                      onPressed: () => deleteAccountTap(userProfileProvider),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                if(userProfileProvider.isLoading)
                  const AppImageLoader(loadingText: 'Please wait,\nRemoving your account details.!')
              ],
            ),
          ),
        );
      },
    );
  }

  Expanded buildBottomSheet(
      BuildContext context, UserProfileProvider userProfileProvider) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.only(
          top: 40,
          left: 35,
          right: 25,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: ColorConstant.grey),
          color: ColorConstant.white,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            buildSheetAppBar(context),
            const SizedBox(height: 20),
            const AppText(
              text: 'If you delete permanently account your loose your chat, requests etc...',
              fontColor: ColorConstant.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            buildFeedbackView(),
            const SizedBox(height: 20),
            AppElevatedButton(
              text: 'Cancel',
              height: 50,
              margin: 0,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            AppOutlinedButton(
              text: 'Confirm Delete Account',
              height: 50,
              margin: 0,
              onPressed: () => deleteAccount(userProfileProvider),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Container buildFeedbackView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorConstant.indicatorColor,
          width: 2,
        ),
      ),
      child: TextFormField(
        controller: feedbackController,
        onChanged: (String? aboutMe) {},
        style: const TextStyle(
          fontFamily: AppTheme.defaultFont,
          fontSize: 16,
          color: ColorConstant.black,
          letterSpacing: 0.48,
        ),
        maxLines: 10,
        decoration: const InputDecoration(
          hintText: 'Feedback',
          fillColor: ColorConstant.hintColor,
          hintStyle: TextStyle(
            fontFamily: AppTheme.defaultFont,
            fontSize: 20,
            color: Color(0XFFBDBDBD),
            letterSpacing: 0.48,
          ),
          filled: false,
          contentPadding: EdgeInsets.all(14),
        ),
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.name,
      ),
    );
  }

  GestureDetector buildSheetAppBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: const BoxDecoration(color: ColorConstant.transparent),
        child: const AppText(
          text: 'Reason',
          fontColor: ColorConstant.pink,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  GestureDetector buildEmailLauncher() {
    return GestureDetector(
      onTap: () {
        urlLauncher(
          url: 'mailto:${StringConstant.contactMail}',
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        color: ColorConstant.transparent,
        padding:
            const EdgeInsets.symmetric(horizontal: 36).copyWith(bottom: 30),
        child: const AppText(
          text: StringConstant.contactMail,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          fontColor: ColorConstant.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Padding buildContactUsTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36)
          .copyWith(top: 50, bottom: 18),
      child: AppText(
        text: title,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        fontColor: ColorConstant.black,
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context, UserProfileProvider userProfileProvider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(userProfileProvider.isLoading ? 0 : AppBar().preferredSize.height),
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                color: ColorConstant.transparent,
                child: const AppImageAsset(image: ImageConstant.circleBackIcon),
              ),
            ),
            const AppText(
              text: 'Need Help',
              fontSize: 22,
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteAccount(UserProfileProvider userProfileProvider) async {
    Navigator.pop(context);
    userProfileProvider.isLoading = true;
    userProfileProvider.notifyListeners();
    await userService.removeUser(context, currentUserId: userProfileProvider.currentUserId);
    await ChatService.removeChat(context, userId: userProfileProvider.currentUserId);
    await logOut();
    userProfileProvider.isLoading = false;
    userProfileProvider.notifyListeners();
  }

  void deleteAccountTap(UserProfileProvider userProfileProvider) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => AppBottomSheet(
          buildBottomView: buildBottomSheet(
            context,
            userProfileProvider,
          ),
        ),
      ),
    );
  }

  Future<void> logOutTap() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const AppText(
          text: 'Are you sure you want logout?',
          fontColor: ColorConstant.black,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => logOut(),
              child: AppText(
                text: 'yes'.toUpperCase(),
                fontColor: ColorConstant.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: AppText(
                text: 'no'.toUpperCase(),
                fontColor: ColorConstant.pink,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logOut() async {
    await authService.userSignOut(context);
    DisposeAllProviders.disposeAllDisposableProviders(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LogInScreen()),
      (route) => false,
    );
  }
}
