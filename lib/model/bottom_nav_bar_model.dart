// To parse this JSON data, do
//
//     final bottomNavBarModel = bottomNavBarModelFromJson(jsonString);

import 'dart:convert';

List<BottomNavBarModel> bottomNavBarModelFromJson(String str) =>
    List<BottomNavBarModel>.from(
        json.decode(str).map((x) => BottomNavBarModel.fromJson(x)));

String bottomNavBarModelToJson(List<BottomNavBarModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BottomNavBarModel {
  BottomNavBarModel({
    this.tabName,
    this.tabImage,
    this.selectedTabImage,
  });

  String? tabName;
  String? tabImage;
  String? selectedTabImage;

  factory BottomNavBarModel.fromJson(Map<String, dynamic> json) =>
      BottomNavBarModel(
        tabName: json["tabName"],
        tabImage: json["tabImage"],
        selectedTabImage: json["selectedTabImage"],
      );

  Map<String, dynamic> toJson() => {
        "tabName": tabName,
        "tabImage": tabImage,
        "selectedTabImage": selectedTabImage,
      };
}
