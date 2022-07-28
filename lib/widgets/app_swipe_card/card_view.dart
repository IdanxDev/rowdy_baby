// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/service/location_service.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_swipe_card/card_buttons.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

class CardView extends StatelessWidget {
  final UserModel? userData;
  final SwipableStackController? swipableStackController;

  const CardView({
    @required this.userData,
    @required this.swipableStackController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, UserProfileProvider>(
      builder: (context, provider, userProfileProvider, child) {
        return Stack(
          children: [
            Hero(
              tag: userData!.userId.toString(),
              child: GestureDetector(
                onTap: () {
                  provider.isDetails = true;
                  provider.notifyListeners();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: AppImageAsset(
                    image: userData!.photos![0],
                    isWebImage: true,
                    webHeight: MediaQuery.of(context).size.height,
                    webWidth: MediaQuery.of(context).size.width,
                    webFit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                provider.isDetails = true;
                provider.notifyListeners();
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, right: 20),
                  child: AppImageAsset(
                    image: ImageConstant.infoIcon,
                    height: 26,
                    width: 26,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: ColorConstant.white,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(26),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black12.withOpacity(0),
                      Colors.black12.withOpacity(.4),
                      Colors.black12.withOpacity(.82),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppText(
                            text: userData!.userName!.toTitleCase(),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(width: 10),
                          if (userData!.isVerified)
                            const AppImageAsset(
                              image: ImageConstant.blueVerifyBadge,
                              height: 18,
                            )
                        ],
                      ),
                      Row(
                        children: [
                          (userData!.cast != null && userData!.cast!.isNotEmpty)
                              ? AppText(text: userData!.cast)
                              : Container(),
                          (userData!.subCaste != null && userData!.subCaste!.isNotEmpty)
                              ? AppText(text: ' \u2022 ${userData!.subCaste}')
                              : Container(),
                          (userData!.religion != null && userData!.religion!.isNotEmpty)
                              ? AppText(text: ' \u2022 ${userData!.religion}')
                              : Container(),
                        ],
                      ),
                      const SizedBox(height: CardButton.height + 30),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
            CardButton(
              kmValue: (userProfileProvider.currentUserData!.location != null && userData!.location != null)
                  ? LocationService.calculateDistance(
                      userProfileProvider.currentUserData!.location!.latitude!,
                      userProfileProvider.currentUserData!.location!.longitude!,
                      // 12.9716,
                      // 77.5946,
                      userData!.location!.latitude,
                      userData!.location!.longitude,
                    )
                  : null,
              onSwipe: (swipeDirection) {
                swipableStackController!.next(swipeDirection: swipeDirection);
              },
            ),
          ],
        );
      },
    );
  }
}
