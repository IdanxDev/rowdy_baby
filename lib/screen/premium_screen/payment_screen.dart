// ignore_for_file: use_build_context_synchronously

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

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<UserProfileProvider>(
        builder: (context, UserProfileProvider userProfileProvider, _) {
          return Consumer<SubscriptionProvider>(
            builder: (context, SubscriptionProvider subscriptionProvider, _) {
              return SafeArea(
                child: Scaffold(
                  appBar: buildAppBar(context),
                  body: ListView(
                    primary: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 36)
                        .copyWith(top: 30),
                    children: [
                      buildFeaturesList(),
                      const SizedBox(height: 30),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 30),
                        itemCount:
                            subscriptionProvider.subscriptionModel.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            color: subscriptionProvider.selectedPlan == index
                                ? ColorConstant.orange
                                : ColorConstant.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color:
                                    subscriptionProvider.selectedPlan == index
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
                                          .subscriptionModel[index]
                                          .planDuration,
                                      fontSize: 20,
                                      fontColor:
                                          subscriptionProvider.selectedPlan ==
                                                  index
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
                                  fontColor:
                                      subscriptionProvider.selectedPlan == index
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
                      AppElevatedButton(
                        text: 'Continue to pay',
                        margin: 0,
                        height: 50,
                        fontSize: 16,
                        onPressed: () => validatePayments(
                            userProfileProvider, subscriptionProvider),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Column buildFeaturesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        premiumFeatures.length,
        (index) => Container(
          color: ColorConstant.transparent,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              const AppImageAsset(
                image: ImageConstant.pinkCheckIcon,
                height: 26,
                width: 26,
              ),
              const SizedBox(width: 12),
              AppText(
                text: premiumFeatures[index],
                fontSize: 18,
                fontColor: ColorConstant.black,
                fontWeight: FontWeight.w500,
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
              text: 'Upgrade to Premium',
              fontSize: 22,
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
            ),
          ],
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
