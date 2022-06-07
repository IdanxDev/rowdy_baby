// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/intro_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/screen/logIn_screen/login_screen.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  PageController? pageViewController = PageController(initialPage: 0);
  Timer? timer;

  List<IntroModel> introModelList = <IntroModel>[
    IntroModel(
        image: ImageConstant.slider1,
        header: 'Choose your partner in your ',
        body: 'own caste'),
    IntroModel(
        image: ImageConstant.slider2,
        header: 'Understanding each other makes ',
        body: ' some time'),
    IntroModel(
      image: ImageConstant.slider3,
      header: 'Love . Date . ',
      body: 'Decide',
    ),
  ];

  @override
  initState() {
    pageViewController = PageController(initialPage: 0);
    AppProvider appProvider = Provider.of(context, listen: false);
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer t) {
        appProvider.changeSlider();
        pageViewController!.animateToPage(appProvider.currentIndex,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    pageViewController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Consumer<AppProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                PageView(
                  controller: pageViewController,
                  onPageChanged: (int? index) {
                    provider.currentIndex = index!;
                    provider.notifyListeners();
                  },
                  children: List.generate(
                    introModelList.length,
                    (index) => AppImageAsset(
                      image: introModelList[index].image!,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                body(provider)
              ],
            );
          },
        ),
      ),
    );
  }

  Column body(AppProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        introText(provider),
        const SizedBox(height: 32),
        startedButton(provider),
        const SizedBox(height: 22),
        indicatorView(provider),
        const SizedBox(height: 36),
      ],
    );
  }

  SizedBox indicatorView(AppProvider provider) {
    return SizedBox(
      height: 22,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: introModelList.length,
        itemBuilder: (context, index) => Container(
          height: 10,
          width: 10,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: provider.currentIndex == index
                ? ColorConstant.orange
                : ColorConstant.white,
          ),
        ),
      ),
    );
  }

  AppElevatedButton startedButton(AppProvider provider) {
    return AppElevatedButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LogInScreen()),
          (route) => false,
        );
      },
      text: 'Get started'.toUpperCase(),
      textSize: 16,
      margin: 36,
      borderRadius: 12,
      height: 50,
    );
  }

  RichText introText(AppProvider provider) {
    return RichText(
      text: TextSpan(
        text: introModelList[provider.currentIndex].header!,
        style: const TextStyle(
          fontFamily: AppTheme.defaultFont,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: introModelList[provider.currentIndex].body!,
            style: const TextStyle(
              color: ColorConstant.orange,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
