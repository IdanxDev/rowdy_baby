// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel profileModel) =>
    json.encode(profileModel.toJson());

class ProfileModel {
  ProfileModel({
    this.userId,
    this.userName,
    this.gender,
    this.photos,
    this.age,
    this.interest,
    this.cast,
    this.religion,
    this.usageType,
    this.height,
    this.maritalStatus,
    this.smoke,
    this.drink,
    this.language,
    this.education,
    this.occupation,
    this.aboutMe,
    this.profilePercentage,
    this.phoneNumber,
    this.emailAddress,
    this.subCaste,
    this.country,
    this.city,
  });

  String? userId;
  String? userName;
  String? gender;
  List<String>? photos;
  String? age;
  String? interest;
  String? cast;
  String? religion;
  String? usageType;
  String? height;
  String? maritalStatus;
  String? smoke;
  String? drink;
  List<String>? language;
  String? education;
  String? occupation;
  String? aboutMe;
  String? phoneNumber;
  String? emailAddress;
  String? subCaste;
  String? country;
  String? city;
  num? profilePercentage;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        userId: json["userId"],
        userName: json["userName"],
        gender: json["gender"],
        photos: json["photos"] == null
            ? null
            : List<String>.from(json["photos"].map((x) => x)),
        age: json["age"],
        interest: json["interest"],
        cast: json["cast"],
        religion: json["religion"],
        usageType: json["usageType"],
        height: json["height"],
        maritalStatus: json["maritalStatus"],
        smoke: json["smoke"],
        drink: json["drink"],
        language: json["language"] == null
            ? null
            : List<String>.from(json["language"].map((x) => x)),
        education: json["education"],
        occupation: json["occupation"],
        aboutMe: json["aboutMe"],
        profilePercentage: json["profilePercentage"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        emailAddress:
            json["emailAddress"] == null ? null : json["emailAddress"],
        subCaste: json["subCaste"] == null ? null : json["subCaste"],
        country: json["country"] == null ? null : json["country"],
        city: json["city"] == null ? null : json["city"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "gender": gender,
        "photos":
            photos == null ? null : List<dynamic>.from(photos!.map((x) => x)),
        "age": age,
        "interest": interest,
        "cast": cast,
        "religion": religion,
        "usageType": usageType,
        "height": height,
        "maritalStatus": maritalStatus,
        "smoke": smoke,
        "drink": drink,
        "language": language == null
            ? null
            : List<dynamic>.from(language!.map((x) => x)),
        "education": education,
        "occupation": occupation,
        "aboutMe": aboutMe,
        "profilePercentage": profilePercentage,
        "phoneNumber": phoneNumber,
        "emailAddress": emailAddress,
        "subCaste": subCaste,
        "country": country,
        "city": city,
      };
}
