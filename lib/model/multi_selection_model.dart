// To parse this JSON data, do
//
//     final multiSelectionModel = multiSelectionModelFromJson(jsonString);

import 'dart:convert';

List<MultiSelectionModel> multiSelectionModelFromJson(String str) =>
    List<MultiSelectionModel>.from(
        json.decode(str).map((x) => MultiSelectionModel.fromJson(x)));

String multiSelectionModelToJson(List<MultiSelectionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MultiSelectionModel {
  MultiSelectionModel({
    this.name,
    this.isSelected = false,
  });

  String? name;
  bool isSelected;

  factory MultiSelectionModel.fromJson(Map<String, dynamic> json) =>
      MultiSelectionModel(
        name: json["name"],
        isSelected: json["isSelected"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "isSelected": isSelected,
      };
}
