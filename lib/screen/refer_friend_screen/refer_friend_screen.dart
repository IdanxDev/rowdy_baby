import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/constant/string_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ReferFriendScreen extends StatefulWidget {
  const ReferFriendScreen({Key? key}) : super(key: key);

  @override
  State<ReferFriendScreen> createState() => ReferFriendScreenState();
}

class ReferFriendScreenState extends State<ReferFriendScreen> {
  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          primary: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 30),
          children: [
            const AppText(
              text:
                  'Refer a friend , you & your friend will receive premium rewards of extra days based on your subscription:',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontColor: Color(0XFF989898),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            const AppText(
              text:
                  '\u2022   1month - 10days extra, Total = 40days\n\u2022   3months - 20days extra, Total = 110days\n\u2022   6months - 30days extra, Total = 210days',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontColor: Color(0XFF989898),
              maxLines: 5,
              height: 1.8,
            ),
            const SizedBox(height: 40),
            AppImageAsset(
              image: 'assets/images/refere-a-patient.png',
              height: 130,
              width: MediaQuery.of(context).size.width / 3,
            ),
            const SizedBox(height: 40),
            buildReferPathView(),
            const SizedBox(height: 40),
            buildReferLinkView(),
          ],
        ),
      ),
    );
  }

  Container buildReferLinkView() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorConstant.pink,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            flex: 2,
            child: AppText(
              text: StringConstant.website,
              fontColor: ColorConstant.pink,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10).copyWith(left: 16, right: 16),
            decoration: BoxDecoration(
              color: ColorConstant.pink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const AppText(text: 'Refer now'),
          ),
        ],
      ),
    );
  }

  Row buildReferPathView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotatedBox(
          quarterTurns: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: ColorConstant.yellow,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 50,
                height: 2,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: ColorConstant.yellow),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: ColorConstant.yellow,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 50,
                height: 2,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: ColorConstant.yellow),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: ColorConstant.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        RotatedBox(
          quarterTurns: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const RotatedBox(
                quarterTurns: -1,
                child: AppText(
                  text: 'Send the referral link',
                  fontColor: ColorConstant.black,
                ),
              ),
              Container(
                width: 40,
                height: 2,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ColorConstant.transparent,
                ),
              ),
              const RotatedBox(
                quarterTurns: -1,
                child: AppText(
                  text: 'Let your friend get sign up',
                  fontColor: ColorConstant.black,
                ),
              ),
              Container(
                width: 40,
                height: 2,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ColorConstant.transparent,
                ),
              ),
              const RotatedBox(
                quarterTurns: -1,
                child: AppText(
                  text: 'Auto apply of your reward',
                  fontColor: ColorConstant.black,
                ),
              ),
            ],
          ),
        ),
      ],
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
              text: 'Refer a Friend',
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
