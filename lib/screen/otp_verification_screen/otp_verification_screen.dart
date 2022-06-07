// ignore_for_file: use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'dart:async';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/screen/profile_module/profile_screen.dart';
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
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    verifyOtp(appProvider);
    counter();
  }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
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
                    RichText(
                      text: TextSpan(
                        text: '${secondsRemaining}sec ',
                        style: const TextStyle(
                          fontFamily: AppTheme.defaultFont,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // setState(() {
                                //   secondsRemaining = 30;
                                // });
                                // counter();
                                // verifyOtp(provider);
                              },
                            text: enableResend ? 'Resend' : '',
                            style: const TextStyle(
                              color: ColorConstant.orange,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
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
                color: ColorConstant.orange,
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
        onPressed: () async {
          setState(() => isLoading = true);
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId!, smsCode: otpController.text);
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(phoneAuthCredential);
          if (userCredential.user != null) {
            provider.userModel.userId = userCredential.user!.uid;
            provider.userModel.phoneNumber =
                userCredential.user!.phoneNumber ?? '';
            logs('Usermodel --> ${provider.userModel.toJson()}');
            provider.userId = provider.userModel.userId!;
            await setPrefBoolValue(isLoggedIn, true);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
              (route) => false,
            );
          }
          setState(() => isLoading = false);
        },
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
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(phoneAuthCredential);
          logs('User --> ${userCredential.user}');
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
            isLoading = false;
          });
        },
        timeout: const Duration(seconds: 120),
      );
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User : ${e.message}');
      showMessage(context, message: e.message, isError: true);
    }
  }

  void counter() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0 && !isLoading) {
        secondsRemaining--;
      } else {
        enableResend = true;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }
}
