// ignore_for_file: use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'dart:async';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/profile_module/profile_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  String? verificationId;
  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;
  final PinTheme pinTheme = PinTheme(
    constraints: const BoxConstraints(minHeight: 60, minWidth: 58),
    height: 60,
    width: 60,
    decoration: BoxDecoration(
      color: ColorConstant.darkPink,
      borderRadius: BorderRadius.circular(10),
    ),
    textStyle: const TextStyle(
      fontFamily: AppTheme.defaultFont,
      fontSize: 16,
      color: ColorConstant.white,
      letterSpacing: 0.48,
    ),
  );
  UserService userService = UserService();
  List<UserModel>? userModelList;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    verifyOtp(appProvider);
  }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> ${runtimeType} : ${enableResend}');
    return WillPopScope(
      onWillPop: () async => true,
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: ColorConstant.pink,
            body: Stack(
              children: [
                ListView(
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 52),
                  children: [
                    headerView(),
                    const SizedBox(height: 10),
                    numberView(provider),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    pinInputView(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    const AppText(
                      text: 'Not Received OTP ?',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        if (enableResend) {
                          timer!.cancel();
                          verifyOtp(provider);
                          secondsRemaining = 30;
                          enableResend = false;
                          setState(() {});
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: '${secondsRemaining}sec ',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          AppText(
                            text: enableResend ? 'Resend' : '',
                            fontSize: 18,
                            fontColor: ColorConstant.lightYellow,
                            decoration: TextDecoration.underline,
                          ),
                        ],
                      ),
                    ),
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

  Padding pinInputView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Pinput(
        controller: otpController,
        mainAxisAlignment: MainAxisAlignment.start,
        defaultPinTheme: pinTheme,
        focusedPinTheme: pinTheme,
        submittedPinTheme: pinTheme,
        followingPinTheme: pinTheme,
        disabledPinTheme: pinTheme,
        errorPinTheme: pinTheme,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        length: 6,
      ),
    );
  }

  Padding numberView(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: RichText(
        text: TextSpan(
          text: '${provider.loginNumber} ',
          style: const TextStyle(
            fontFamily: AppTheme.defaultFont,
            fontSize: 16,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Change',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pop(context),
              style: const TextStyle(
                color: ColorConstant.lightYellow,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding headerView() {
    return const Padding(
      padding: EdgeInsets.only(left: 32),
      child: AppText(
        text: 'Enter OTP',
        fontColor: ColorConstant.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Padding fabView(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FloatingActionButton(
        backgroundColor: ColorConstant.white,
        elevation: 0,
        onPressed: () => validateOtp(provider),
        child: const AppImageAsset(
          image: ImageConstant.forwardArrowIcon,
          height: 20,
          width: 20,
        ),
      ),
    );
  }

  Future<void> verifyOtp(AppProvider appProvider) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: appProvider.loginNumber!,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          // UserCredential userCredential = await FirebaseAuth.instance
          //     .signInWithCredential(phoneAuthCredential);
          // logs('User --> ${userCredential.user}');
        },
        verificationFailed: (FirebaseAuthException error) {
          if (error.code == 'invalid-phone-number') {
            showMessage(context,
                message: 'The provided phone number is not valid.',
                isError: true);
          } else if (error.code == 'firebase_auth/invalid-verification-code') {
            showMessage(context,
                message: 'The provided OTP is not valid.', isError: true);
          } else {
            showMessage(context, message: error.message);
          }
        },
        codeSent: (String? verificationId, int? forceResendingToken) async {
          logs('code message --> ${verificationId}');
          setState(() {
            this.verificationId = verificationId;
            isLoading = false;
          });
          counter();
          // PhoneAuthCredential phoneAuthCredential =
          //     PhoneAuthProvider.credential(
          //         verificationId: this.verificationId!, smsCode: '111111');
          // UserCredential userCredential = await FirebaseAuth.instance
          //     .signInWithCredential(phoneAuthCredential);
          // logs('User --> ${userCredential.user}');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          logs('VerifyId --> $verificationId');
          setState(() {
            this.verificationId = verificationId;
            // isLoading = false;
          });
        },
        timeout: const Duration(seconds: 30),
      );
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User : ${e.message}');
      showMessage(context, message: e.message, isError: true);
    }
  }

  void counter() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        secondsRemaining--;
      } else {
        enableResend = true;
      }
      if (mounted && secondsRemaining >= 0) {
        setState(() {});
      }
    });
  }

  Future<void> getAllUsers(AppProvider provider) async {
    userModelList = await userService.getAllUsers(context);
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
    }
  }

  validateOtp(AppProvider provider) async {
    if (otpController.text.isEmpty) {
      showMessage(context, message: 'Please enter 6 digit otp', isError: true);
    } else if (otpController.text.length != 6) {
      showMessage(context,
          message: 'Otp must contains 6 digits', isError: true);
    } else {
      setState(() => isLoading = true);
      try {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: verificationId!, smsCode: otpController.text);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential);
        if (userCredential.user != null) {
          await userService.deleteUser(context, currentUserId: userCredential.user!.uid);
          provider.userModel.userId = userCredential.user!.uid;
          provider.userModel.phoneNumber =
              userCredential.user!.phoneNumber ?? '';
          provider.userModel.emailAddress = userCredential.user!.email ?? '';
          provider.userModel.logInType = 'phone';
          logs('Usermodel --> ${provider.userModel.toJson()}');
          provider.userId = provider.userModel.userId!;
          await setPrefBoolValue(isLoggedIn, true);
          await getAllUsers(provider);
        }
      } on FirebaseAuthException catch (e) {
        showMessage(context, message: e.message, isError: true);
      }
      setState(() => isLoading = false);
    }
  }
}
