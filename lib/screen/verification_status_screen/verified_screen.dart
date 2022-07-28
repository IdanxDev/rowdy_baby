import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class VerifiedScreen extends StatefulWidget {
  const VerifiedScreen({Key? key}) : super(key: key);

  @override
  State<VerifiedScreen> createState() => VerifiedScreenState();
}

class VerifiedScreenState extends State<VerifiedScreen> {
  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            primary: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 50),
            children: const [
              AppImageAsset(
                image: 'assets/icons/verified_large_badge.svg',
                height: 60,
              ),
              SizedBox(height: 20),
              AppText(
                text: 'Your profile has successfully Verified',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontColor: ColorConstant.pink,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AppText(
                  text:
                      'Congratulations! you got a verified badge on your profile, you have more chances to get matches and messages,',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontColor: ColorConstant.black,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
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
              text: 'Get verified',
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
