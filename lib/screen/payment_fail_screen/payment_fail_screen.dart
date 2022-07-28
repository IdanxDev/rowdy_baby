// ignore_for_file: use_build_context_synchronously

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/string_constant.dart';
import 'package:dating/provider/premium_screen/premium_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/premium_member_screen/premium_member_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PaymentFailScreen extends StatefulWidget {
  const PaymentFailScreen({Key? key}) : super(key: key);

  @override
  State<PaymentFailScreen> createState() => PaymentFailScreenState();
}

class PaymentFailScreenState extends State<PaymentFailScreen> {
  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              primary: true,
              padding: const EdgeInsets.only(top: 60),
              physics: const BouncingScrollPhysics(),
              children: [
                Lottie.asset('assets/animations/Payment Failed.json',
                    height: 60),
                const SizedBox(height: 10),
                const AppText(
                  text: 'Payment Failed',
                  textAlign: TextAlign.center,
                  fontSize: 22,
                  fontColor: Color(0xffE63946),
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38),
                  child: AppText(
                    text:
                        'Your transaction has failed due to some technical error. please try again',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontColor: ColorConstant.dropShadow,
                    fontWeight: FontWeight.bold,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer2<UserProfileProvider, SubscriptionProvider>(
                  builder: (c, userProfileProvider, subscriptionProvider, _) {
                    return AppElevatedButton(
                      text: 'Try with Other Payment Methods',
                      fontSize: 14,
                      height: 50,
                      onPressed: () => initializePayment(
                          userProfileProvider, subscriptionProvider),
                    );
                  },
                ),
                const SizedBox(height: 20),
                AppElevatedButton(
                  text: 'Cancel Payment',
                  fontSize: 18,
                  height: 50,
                  fontColor: ColorConstant.black,
                  buttonColor: ColorConstant.themeScaffold,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            )
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
}
