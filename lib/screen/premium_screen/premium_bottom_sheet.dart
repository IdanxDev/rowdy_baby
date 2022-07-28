// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/constant/string_constant.dart';
import 'package:dating/provider/premium_screen/premium_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/default_screen/phone_email_bottom_sheet.dart';
import 'package:dating/screen/payment_fail_screen/payment_fail_screen.dart';
import 'package:dating/screen/premium_member_screen/premium_member_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PremiumBottomSheet extends StatefulWidget {
  const PremiumBottomSheet({Key? key}) : super(key: key);

  @override
  State<PremiumBottomSheet> createState() => PremiumBottomSheetState();
}

class PremiumBottomSheetState extends State<PremiumBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer2<UserProfileProvider, SubscriptionProvider>(
        builder: (BuildContext context, UserProfileProvider userProfileProvider,
            SubscriptionProvider subscriptionProvider, _) {
          return Scaffold(
            backgroundColor: ColorConstant.transparent.withOpacity(0.5),
            body: Column(
              children: [
                buildSheetBarrierView(context),
                buildSheetView(context, subscriptionProvider, userProfileProvider),
              ],
            ),
            bottomNavigationBar: Container(
              color: ColorConstant.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: AppElevatedButton(
                text: 'Continue to pay',
                margin: 30,
                height: 50,
                fontSize: 16,
                onPressed: () {
                  validatePayments(userProfileProvider, subscriptionProvider);
                },
              ),
            ),
            // const SizedBox(height: 34),,
          );
        },
      ),
    );
  }

  Expanded buildSheetView(
      BuildContext context,
      SubscriptionProvider subscriptionProvider,
      UserProfileProvider userProfileProvider) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.only(top: 40, left: 35, right: 25),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          // border: Border.all(color: ColorConstant.grey),
          color: ColorConstant.white,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            buildSheetAppBar(context),
            const SizedBox(height: 10),
            const AppText(
              text: 'Become a premium member then you can get',
              fontColor: ColorConstant.black,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.normal,
              fontSize: 16,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppImageAsset(
                        image: ImageConstant.pinkCheckIcon,
                        height: 19,
                        width: 19,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: AppText(
                          text: premiumFeatures[0],
                          fontSize: 14,
                          fontColor: ColorConstant.black,
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppImageAsset(
                        image: ImageConstant.pinkCheckIcon,
                        height: 19,
                        width: 19,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: AppText(
                          text: premiumFeatures[1],
                          fontSize: 14,
                          fontColor: ColorConstant.black,
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppImageAsset(
                        image: ImageConstant.pinkCheckIcon,
                        height: 19,
                        width: 19,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: AppText(
                          text: premiumFeatures[2],
                          fontSize: 14,
                          fontColor: ColorConstant.black,
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppImageAsset(
                        image: ImageConstant.pinkCheckIcon,
                        height: 19,
                        width: 19,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: AppText(
                          text: premiumFeatures[3],
                          fontSize: 14,
                          fontColor: ColorConstant.black,
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.separated(
              primary: true,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: subscriptionProvider.subscriptionModel.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: subscriptionProvider.selectedPlan == index
                      ? ColorConstant.orange
                      : ColorConstant.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: subscriptionProvider.selectedPlan == index
                          ? ColorConstant.transparent
                          : ColorConstant.dropShadow,
                      width: 1,
                    ),
                  ),
                  child: SizedBox(
                    height: 58,
                    child: ListTile(
                      onTap: () {
                        subscriptionProvider.changePremiumPlan(index);
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: subscriptionProvider
                                .subscriptionModel[index].planDuration,
                            fontSize: 20,
                            fontColor:
                                subscriptionProvider.selectedPlan == index
                                    ? ColorConstant.white
                                    : ColorConstant.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                          if (subscriptionProvider
                              .subscriptionModel[index].isPopular)
                            const AppText(
                              text: 'Popular',
                              fontSize: 14,
                              fontColor: ColorConstant.white,
                              fontWeight: FontWeight.w400,
                            ),
                        ],
                      ),
                      trailing: AppText(
                        text:
                            '${subscriptionProvider.subscriptionModel[index].planPrice} Rs',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontColor: subscriptionProvider.selectedPlan == index
                            ? ColorConstant.white
                            : ColorConstant.black,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  AppText buildSheetAppBar(BuildContext context) {
    return const AppText(
      text: 'Upgrade to Premium',
      fontColor: ColorConstant.pink,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.center,
      fontSize: 22,
      maxLines: 2,
    );
  }

  Expanded buildSheetBarrierView(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: ColorConstant.transparent,
          width: double.infinity,
        ),
      ),
    );
  }

  Future<void> initializePayment(UserProfileProvider userProfileProvider,
      SubscriptionProvider subscriptionProvider) async {
    String orderId = 'rowdy${DateTime.now().microsecondsSinceEpoch}';
    String? cfToken =
        await subscriptionProvider.getCfToken(context, orderId: orderId);
    if (cfToken != null && cfToken.isNotEmpty) {
      logs('Token --> $cfToken');
      Map<String, String> paymentParams = {
        'orderId': orderId,
        'orderAmount':
            '${subscriptionProvider.subscriptionModel[subscriptionProvider.selectedPlan].planPrice}',
        'customerName': userProfileProvider.currentUserData!.userName!,
        'orderNote':
            '${subscriptionProvider.subscriptionModel[subscriptionProvider.selectedPlan].planDuration}',
        'orderCurrency': 'INR',
        'appId': '17680219264356bed32cd160c1208671',
        'customerPhone': (userProfileProvider.currentUserData!.phoneNumber !=
                    null &&
                userProfileProvider.currentUserData!.phoneNumber!.isNotEmpty)
            ? userProfileProvider.currentUserData!.phoneNumber!
            : '1234567890',
        'customerEmail': (userProfileProvider.currentUserData!.emailAddress !=
                    null &&
                userProfileProvider.currentUserData!.emailAddress!.isNotEmpty)
            ? userProfileProvider.currentUserData!.emailAddress!
            : StringConstant.contactMail,
        'stage': 'TEST',
        'tokenData': cfToken,
      };
      logs('Payment params --> $paymentParams');
      Map<dynamic, dynamic>? paymentMap =
          await CashfreePGSDK.doPayment(paymentParams);
      logs('Payment map --> $paymentMap');
      if (paymentMap!['txStatus'] == 'SUCCESS') {
        getPremiumUser(userProfileProvider, subscriptionProvider);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentFailScreen()),
        );
      }
    }
  }

  Future<void> getPremiumUser(UserProfileProvider userProfileProvider,
      SubscriptionProvider subscriptionProvider) async {
    DateTime today = DateTime.now();
    String planExpiryDate = subscriptionProvider.selectedPlan == 0
        ? DateTime(today.year, today.month + 1, today.day).toIso8601String()
        : subscriptionProvider.selectedPlan == 1
            ? DateTime(today.year, today.month + 3, today.day).toIso8601String()
            : DateTime(today.year, today.month + 6, today.day)
                .toIso8601String();
    logs('Expiry date --> $planExpiryDate');
    await UserService().upgradeToPremium(
      context,
      currentUserId: userProfileProvider.currentUserId,
      planExpiryDate: planExpiryDate,
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const PremiumMemberScreen(showAnimation: true)),
      (route) => false,
    );
  }

  Future<void> validatePayments(UserProfileProvider userProfileProvider,
      SubscriptionProvider subscriptionProvider) async {
    await userProfileProvider.getCurrentUserData(context);
    if (userProfileProvider.currentUserData!.phoneNumber == null ||
        userProfileProvider.currentUserData!.phoneNumber!.isEmpty) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => const EmailPhoneBottomSheet(),
        ),
      );
    } else if (userProfileProvider.currentUserData!.emailAddress == null ||
        userProfileProvider.currentUserData!.emailAddress!.isEmpty) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) =>
              const EmailPhoneBottomSheet(isPhone: false),
        ),
      );
    } else {
      initializePayment(userProfileProvider, subscriptionProvider);
    }
  }
}
