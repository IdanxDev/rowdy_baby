// To parse this JSON data, do
//
//     final advanceFilterListModel = advanceFilterListModelFromJson(jsonString);

import 'dart:convert';

import 'package:dating/model/multi_selection_model.dart';

List<AdvanceFilterListModel> advanceFilterListModelFromJson(String str) =>
    List<AdvanceFilterListModel>.from(
        json.decode(str).map((x) => AdvanceFilterListModel.fromJson(x)));

String advanceFilterListModelToJson(List<AdvanceFilterListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdvanceFilterListModel {
  AdvanceFilterListModel({
    this.sheetTitle,
    this.sheetOptions,
  });

  String? sheetTitle;
  List<MultiSelectionModel>? sheetOptions;

  factory AdvanceFilterListModel.fromJson(Map<String, dynamic> json) =>
      AdvanceFilterListModel(
        sheetTitle: json["sheetTitle"],
        sheetOptions:
            List<MultiSelectionModel>.from(json["sheetOptions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "sheetTitle": sheetTitle,
        "sheetOptions": List<dynamic>.from(sheetOptions!.map((x) => x)),
      };
}
