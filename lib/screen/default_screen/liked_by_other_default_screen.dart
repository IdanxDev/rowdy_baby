import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/premium_screen/payment_screen.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikedByOthersDefaultScreen extends StatefulWidget {
  const LikedByOthersDefaultScreen({Key? key}) : super(key: key);

  @override
  State<LikedByOthersDefaultScreen> createState() =>
      LikedByOthersDefaultScreenState();
}

class LikedByOthersDefaultScreenState
    extends State<LikedByOthersDefaultScreen> {
  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return ListView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      children: [
        buildAppBarView(),
        const SizedBox(height: 200),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: AppImageAsset(
            image: ImageConstant.likedBOtherDefault,
            height: 100,
          ),
        ),
        const SizedBox(height: 30),
        Consumer<UserProfileProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppText(
                text: provider.currentUserData!.isPremiumUser
                    ? 'Swipe right and keep change filters to get more matches'
                    : 'You both are swipe right each other, you can see here, take premium and see who liked you and accept their requests.',
                textAlign: TextAlign.center,
                fontColor: ColorConstant.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                maxLines: 5,
              ),
            );
          },
        ),
        // if (!widget.isLoader)
        //   AppElevatedButton(
        //     text: 'Upgrade to Premium',
        //     height: 50,
        //     padding: MaterialStateProperty.all(EdgeInsets.zero),
        //     borderRadius: 10,
        //     fontSize: 14,
        //     margin: 60,
        //   ),
      ],
    );
  }

  Consumer2<AppProvider, UserProfileProvider> buildAppBarView() {
    return Consumer2<AppProvider, UserProfileProvider>(
      builder: (context, AppProvider appProvider,
          UserProfileProvider userProfileProvider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: ColorConstant.pink,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppImageAsset(
                image: ImageConstant.whiteHeartIcon,
                width: 34,
              ),
              const SizedBox(height: 10),
              const AppText(
                text: 'See who liked you',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              const SizedBox(height: 10),
              if (!userProfileProvider.currentUserData!.isPremiumUser)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: AppText(
                    text:
                        'Upgrade to Rowdy baby premium to see the people who have already SWIPED RIGHT on you',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (!userProfileProvider.currentUserData!.isPremiumUser)
                const SizedBox(height: 20),
              if (!userProfileProvider.currentUserData!.isPremiumUser)
                AppElevatedButton(
                  text: 'Upgrade to Premium',
                  fontSize: 14,
                  buttonColor: ColorConstant.yellow,
                  height: 46,
                  width: 200,
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
        );
      },
    );
  }
}
