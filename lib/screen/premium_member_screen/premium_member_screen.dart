import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/premium_screen/payment_screen.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PremiumMemberScreen extends StatefulWidget {
  final bool showAnimation;

  const PremiumMemberScreen({Key? key, this.showAnimation = false})
      : super(key: key);

  @override
  State<PremiumMemberScreen> createState() => PremiumMemberScreenState();
}

class PremiumMemberScreenState extends State<PremiumMemberScreen> {
  bool showUi = false;

  @override
  initState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showUi = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<AppProvider>(
        builder: (context, AppProvider appProvider, _) {
          return Consumer<UserProfileProvider>(
            builder: (context, UserProfileProvider userProfileProvider, _) {
              return SafeArea(
                child: Scaffold(
                  appBar: buildAppBar(context, appProvider),
                  body: buildBodyView(userProfileProvider),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Stack buildBodyView(UserProfileProvider userProfileProvider) {
    return Stack(
      children: [
        if (widget.showAnimation)
          Lottie.asset(
            'assets/animations/Payment Successful.json',
            repeat: false,
          ),
        if (!widget.showAnimation || showUi)
          ListView(
            primary: true,
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 36).copyWith(top: 30),
            children: [
              const AppImageAsset(
                image: ImageConstant.appIcon,
                height: 82,
                width: 104,
              ),
              const SizedBox(height: 32),
              const AppText(
                text: 'Your Premium Member',
                fontColor: ColorConstant.pink,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const AppText(
                text: 'We hope your most loveable person',
                fontColor: ColorConstant.grey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              const AppText(
                text: 'Your Premium will expire on',
                fontColor: ColorConstant.black,
                fontSize: 18,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppText(
                text: expiryDate(
                  userProfileProvider.currentUserData!.planExpiryDate ??
                      DateTime.now().toIso8601String(),
                ),
                fontColor: ColorConstant.yellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              AppElevatedButton(
                text: 'Upgrade Plan',
                fontSize: 16,
                height: 50,
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
      ],
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(selectedIndex: 0),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                color: ColorConstant.transparent,
                child: const AppImageAsset(image: ImageConstant.circleBackIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
