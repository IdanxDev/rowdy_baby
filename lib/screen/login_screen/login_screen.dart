// ignore_for_file: use_build_context_synchronously

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/constant/string_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/otp_verification_screen/otp_verification_screen.dart';
import 'package:dating/screen/profile_module/profile_screen.dart';
import 'package:dating/service/auth_service.dart';
import 'package:dating/service/notification_service.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_social_button.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => LogInScreenState();
}

class LogInScreenState extends State<LogInScreen> {
  String? countryCode = '+91';
  final TextEditingController numberController = TextEditingController();
  AuthService authService = AuthService();
  UserService userService = UserService();
  NotificationService notificationService = NotificationService();
  List<UserModel>? userModelList;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: ColorConstant.pink,
            body: Stack(
              children: [
                ListView(
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 36, top: 52),
                  children: [
                    headerView(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    countryPickerView(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    orView(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                    AppSocialMediaButton(
                      text: 'Login with Facebook',
                      image: ImageConstant.facebookIcon,
                      onTap: () => facebookSignIn(provider),
                    ),
                    const SizedBox(height: 34),
                    AppSocialMediaButton(
                      text: 'Sign in with Google',
                      image: ImageConstant.googleIcon,
                      onTap: () => googleSignIn(provider),
                    ),
                    const SizedBox(height: 34),
                    termsPrivacyView(),
                  ],
                ),
                isLoading ? const AppLoader() : const SizedBox(),
              ],
            ),
            floatingActionButton: fabView(provider),
          );
        },
      ),
    );
  }

  AppText headerView() {
    return const AppText(
      text: 'Mobile Number',
      fontColor: ColorConstant.white,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    );
  }

  Padding fabView(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FloatingActionButton(
        backgroundColor: ColorConstant.white,
        elevation: 0,
        onPressed: () {
          if (numberController.text.isNotEmpty &&
              numberController.text.length == 10) {
            provider.loginNumber = '$countryCode${numberController.text}';
            logs('Requested number --> ${provider.loginNumber}');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OtpVerificationScreen()),
            );
          } else if (numberController.text.isEmpty) {
            showMessage(context,
                message: 'Phone number can\'t be empty', isError: true);
          } else {
            showMessage(context,
                message: 'Phone number must contains at least 10 digits',
                isError: true);
          }
        },
        child: const AppImageAsset(
          image: ImageConstant.forwardArrowIcon,
          height: 20,
          width: 20,
        ),
      ),
    );
  }

  Padding termsPrivacyView() {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: RichText(
        text: TextSpan(
          text: 'By signing up, you agree to our ',
          style: const TextStyle(
              fontFamily: AppTheme.defaultFont, fontSize: 14, height: 2),
          children: <TextSpan>[
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  urlLauncher(url: StringConstant.termsCondition);
                },
              text: 'Terms & Services',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            const TextSpan(text: ' See how we use your data in our '),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  urlLauncher(url: StringConstant.privacyPolicy);
                },
              text: 'Privacy Policy',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding orView() {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: AppText(
        text: 'or'.toUpperCase(),
        fontSize: 16,
        textAlign: TextAlign.center,
      ),
    );
  }

  Row countryPickerView() {
    return Row(
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: ColorConstant.darkPink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CountryCodePicker(
            onChanged: (CountryCode countryCode) {
              this.countryCode = countryCode.dialCode;
            },
            padding: EdgeInsets.zero,
            initialSelection: 'IN',
            textStyle: const TextStyle(
              color: ColorConstant.white,
              fontSize: 16,
              fontFamily: AppTheme.defaultFont,
              fontWeight: FontWeight.w400,
            ),
            boxDecoration: BoxDecoration(
              color: ColorConstant.darkPink,
              borderRadius: BorderRadius.circular(12),
            ),
            dialogTextStyle: const TextStyle(
              color: ColorConstant.white,
              fontSize: 16,
              fontFamily: AppTheme.defaultFont,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: TextFormField(
            controller: numberController,
            style: const TextStyle(
              fontFamily: AppTheme.defaultFont,
              fontSize: 16,
              color: ColorConstant.white,
              letterSpacing: 0.48,
            ),
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Enter mobile number',
            ),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }

  Future<void> googleSignIn(AppProvider provider) async {
    setState(() => isLoading = true);
    UserCredential? userCredential =
        await authService.signInWithGoogle(context);
    if (userCredential != null) {
      await userService.deleteUser(context, currentUserId: userCredential.user!.uid);
      provider.userModel.userId = userCredential.user!.uid;
      provider.userModel.userName = userCredential.user!.displayName;
      provider.userModel.phoneNumber = userCredential.user!.phoneNumber ?? '';
      provider.userModel.emailAddress = userCredential.user!.email ?? '';
      provider.userModel.logInType = 'social';
      logs('Usermodel --> ${provider.userModel.toJson()}');
      provider.userId = provider.userModel.userId!;
      provider.nameController.text = userCredential.user!.displayName!;
      String? fcmToken = await NotificationService.generateFCMToken(context);
      await userService.updateProfile(context,
          currentUserId: provider.userId, key: 'fcmToken', value: fcmToken,showError: false);
      await setPrefBoolValue(isLoggedIn, true);
      await getAllUsers(provider);
    }
    setState(() => isLoading = false);
  }

  Future<void> facebookSignIn(AppProvider provider) async {
    setState(() => isLoading = true);
    UserCredential? userCredential =
        await authService.signInWithFacebook(context);
    if (userCredential != null) {
      await userService.deleteUser(context, currentUserId: userCredential.user!.uid);
      provider.userModel.userId = userCredential.user!.uid;
      provider.userModel.userName = userCredential.user!.displayName;
      provider.userModel.phoneNumber = userCredential.user!.phoneNumber ?? '';
      provider.userModel.emailAddress = userCredential.user!.email ?? '';
      provider.userModel.logInType = 'social';
      logs('Usermodel --> ${provider.userModel.toJson()}');
      provider.userId = provider.userModel.userId!;
      provider.nameController.text = userCredential.user!.displayName!;
      String? fcmToken = await NotificationService.generateFCMToken(context);
      await userService.updateProfile(context,
          currentUserId: provider.userId, key: 'fcmToken', value: fcmToken,showError: false);
      await setPrefBoolValue(isLoggedIn, true);
      await getAllUsers(provider);
    }
    setState(() => isLoading = false);
  }

  Future<void> getAllUsers(AppProvider provider) async {
    userModelList = await userService.getAllUsers(context, showError: false);
    bool isOldUser = userModelList!
        .any((element) => element.userId == provider.userModel.userId);
    if (isOldUser) {
      showMessage(
        context,
        message: 'Welcome back to Rowdy baby',
      );
      await setPrefBoolValue(isProfileCompleted, true);
      await setPrefBoolValue(isPDCompleted, true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
        (route) => false,
      );
      provider.selectedProfileIndex = 1;
    }
  }
}
