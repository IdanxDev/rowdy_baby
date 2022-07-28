import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/constant/string_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  final EdgeInsetsGeometry bodyPadding =
      const EdgeInsets.symmetric(horizontal: 35, vertical: 20);

  @override
  Widget build(BuildContext context) {
    logs('Current screen -> $runtimeType');
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildBodyView(),
      ),
    );
  }

  Column buildBodyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAboutView(),
        Padding(
          padding: bodyPadding,
          child: const AppText(
            text: 'Website',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontColor: ColorConstant.black,
          ),
        ),
        GestureDetector(
          onTap: () => urlLauncher(url: 'https://${StringConstant.website}'),
          child: Container(
            padding: bodyPadding,
            color: ColorConstant.transparent,
            child: const AppText(
              text: StringConstant.website,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontColor: ColorConstant.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Expanded buildAboutView() {
    return Expanded(
      flex: 8,
      child: ListView(
        primary: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 30),
        children: [
          GestureDetector(
            onTap: () {
              urlLauncher(url: StringConstant.termsCondition);
            },
            child: buildCastReligionView('Terms and Conditions'),
          ),
          GestureDetector(
            onTap: () {
              urlLauncher(url: StringConstant.privacyPolicy);
            },
            child: buildCastReligionView('Privacy Policy'),
          ),
        ],
      ),
    );
  }

  Container buildCastReligionView(String title) {
    return Container(
      padding: bodyPadding,
      decoration: const BoxDecoration(color: ColorConstant.transparent),
      child: Row(
        children: [
          AppText(
            text: title,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontColor: ColorConstant.black,
          ),
          const Spacer(),
          const AppImageAsset(
            image: ImageConstant.forwardIcon,
            height: 18,
          ),
        ],
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height),
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
              text: 'About Us',
              fontSize: 22,
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
