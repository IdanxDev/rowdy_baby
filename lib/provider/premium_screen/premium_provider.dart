// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dating/model/subscription_model.dart';
import 'package:dating/provider/disposable_provider/disposable_provider.dart';
import 'package:dating/service/rest_service.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';

class SubscriptionProvider extends DisposableProvider {
  int selectedPlan = 1;
  List<SubscriptionModel> subscriptionModel = [
    SubscriptionModel(planDuration: '1 Month', planPrice: 199),
    SubscriptionModel(planDuration: '3 Month', planPrice: 499, isPopular: true),
    SubscriptionModel(planDuration: '6 Month', planPrice: 699),
  ];

  void changePremiumPlan(int index) {
    selectedPlan = index;
    notifyListeners();
  }

  Future<String?> getCfToken(BuildContext context,
      {@required String? orderId}) async {
    Map<String, dynamic> bodyMap = {
      'orderId': orderId,
      'orderAmount': '${subscriptionModel[selectedPlan].planPrice}',
      'orderCurrency': 'INR'
    };
    logs('TokenMap --> $bodyMap');
    final cfTokenGen = await RestServices().postRestCall(context,
        endpoint: RestConstants.cfTokenGen, body: bodyMap);
    if (cfTokenGen != null && cfTokenGen.isNotEmpty) {
      Map<String, dynamic> tokenMap = jsonDecode(cfTokenGen);
      if (tokenMap['status'] == 'OK') {
        return tokenMap['cftoken']!;
      } else {
        showMessage(context, message: tokenMap['message'], isError: true);
        return null;
      }
    }
    return null;
  }

  @override
  void disposeAllValues() {
    // TODO: implement disposeAllValues
  }

  @override
  void disposeValues() {
    selectedPlan = 1;
    subscriptionModel = [
      SubscriptionModel(planDuration: '1 Month', planPrice: 199),
      SubscriptionModel(planDuration: '3 Month', planPrice: 499, isPopular: true),
      SubscriptionModel(planDuration: '6 Month', planPrice: 699),
    ];
  }
}
