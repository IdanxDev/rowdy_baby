// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  CityModel({
    this.error = true,
    this.message,
    this.data,
  });

  bool error;
  String? message;
  List<String>? data;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        error: json["error"],
        message: json["msg"],
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": message,
        "data": List<dynamic>.from(data!.map((x) => x)),
      };
}
