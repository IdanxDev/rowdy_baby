// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

List<SubscriptionModel> subscriptionModelFromJson(String str) =>
    List<SubscriptionModel>.from(
        json.decode(str).map((x) => SubscriptionModel.fromJson(x)));

String subscriptionModelToJson(List<SubscriptionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionModel {
  SubscriptionModel({
    this.planDuration,
    this.planPrice,
    this.isPopular = false,
  });

  String? planDuration;
  num? planPrice;
  bool isPopular;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        planDuration: json["planDuration"],
        planPrice: json["planPrice"],
        isPopular: json["isPopular"],
      );

  Map<String, dynamic> toJson() => {
        "planDuration": planDuration,
        "planPrice": planPrice,
        "isPopular": isPopular,
      };
}
