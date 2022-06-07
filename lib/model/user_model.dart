// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.userId,
    this.userName,
    this.phoneNumber,
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
    this.isPremiumUser = false,
    this.planExpiryDate,
  });

  String? userId;
  String? userName;
  String? phoneNumber;
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
  bool isPremiumUser;
  String? planExpiryDate;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        userName: json["userName"],
        phoneNumber: json["phoneNumber"],
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
        isPremiumUser: json["isPremiumUser"],
        planExpiryDate: json["planExpiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "phoneNumber": phoneNumber,
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
        "isPremiumUser": isPremiumUser,
        "planExpiryDate": planExpiryDate,
      };
}
