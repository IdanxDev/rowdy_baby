// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.userId,
    this.userName,
    this.phoneNumber,
    this.emailAddress,
    this.gender,
    this.photos,
    this.age,
    this.interest,
    this.cast,
    this.subCaste,
    this.religion,
    this.usageType,
    this.country,
    this.city,
    this.height,
    this.maritalStatus,
    this.smoke,
    this.drink,
    this.language,
    this.education,
    this.occupation,
    this.aboutMe,
    this.isVerified = false,
    this.isPremiumUser = false,
    this.planExpiryDate,
    this.lastOnline,
    this.userFilter,
    this.swipedIds,
    this.blockedUser,
    this.likedByMe,
    this.rejectedByMe,
    this.likedByOther,
    this.acceptedLikesByOther,
    this.chatByMe,
    this.isEdited = 0,
    this.fcmToken,
    this.userStatus = false,
    this.logInType,
    this.location,
    this.isAvailable = true,
    this.isVerificationApplied,
  });

  String? userId;
  String? userName;
  String? phoneNumber;
  String? emailAddress;
  String? gender;
  List<String>? photos;
  String? age;
  String? interest;
  String? cast;
  String? subCaste;
  String? religion;
  String? usageType;
  String? country;
  String? city;
  String? height;
  String? maritalStatus;
  String? smoke;
  String? drink;
  List<String>? language;
  String? education;
  String? occupation;
  String? aboutMe;
  bool isVerified;
  bool isPremiumUser;
  String? planExpiryDate;
  String? lastOnline;
  UserFilter? userFilter;
  List<String>? swipedIds;
  List<String>? blockedUser;
  List<UserTimeModel>? likedByMe;
  List<UserTimeModel>? rejectedByMe;
  List<String>? likedByOther;
  List<String>? acceptedLikesByOther;
  List<String>? chatByMe;
  num isEdited;
  String? fcmToken;
  bool userStatus;
  String? logInType;
  Location? location;
  bool isAvailable;
  String? isVerificationApplied;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        logInType: json["logInType"] == null ? null : json["logInType"],
        userId: json["userId"] == null ? null : json["userId"],
        userName: json["userName"] == null ? null : json["userName"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        emailAddress:
            json["emailAddress"] == null ? null : json["emailAddress"],
        gender: json["gender"] == null ? null : json["gender"],
        photos: json["photos"] == null
            ? null
            : List<String>.from(json["photos"].map((x) => x)),
        age: json["age"] == null ? null : json["age"],
        interest: json["interest"] == null ? null : json["interest"],
        cast: json["cast"] == null ? null : json["cast"],
        subCaste: json["subCaste"] == null ? null : json["subCaste"],
        religion: json["religion"] == null ? null : json["religion"],
        usageType: json["usageType"] == null ? null : json["usageType"],
        country: json["country"] == null ? null : json["country"],
        city: json["city"] == null ? null : json["city"],
        height: json["height"] == null ? null : json["height"],
        maritalStatus:
            json["maritalStatus"] == null ? null : json["maritalStatus"],
        smoke: json["smoke"] == null ? null : json["smoke"],
        drink: json["drink"] == null ? null : json["drink"],
        language: json["language"] == null
            ? null
            : List<String>.from(json["language"].map((x) => x)),
        education: json["education"] == null ? '' : json["education"],
        occupation: json["occupation"] == null ? '' : json["occupation"],
        aboutMe: json["aboutMe"] == null ? '' : json["aboutMe"],
        isVerified: json["isVerified"] == null ? false : json["isVerified"],
        isPremiumUser:
            json["isPremiumUser"] == null ? false : json["isPremiumUser"],
        planExpiryDate:
            json["planExpiryDate"] == null ? null : json["planExpiryDate"],
        lastOnline: json["lastOnline"] == null
            ? DateTime.now().toIso8601String()
            : json["lastOnline"],
        userFilter: json["userFilter"] == null
            ? null
            : UserFilter.fromJson(json["userFilter"]),
        swipedIds: json["swipedIds"] == null
            ? null
            : List<String>.from(json["swipedIds"].map((x) => x)),
        blockedUser: json["blockedUser"] == null
            ? null
            : List<String>.from(json["blockedUser"].map((x) => x)),
        likedByMe: json["likedByMe"] == null
            ? null
            : List<UserTimeModel>.from(
                json["likedByMe"].map((x) => UserTimeModel.fromJson(x))),
        rejectedByMe: json["rejectedByMe"] == null
            ? null
            : List<UserTimeModel>.from(
                json["rejectedByMe"].map((x) => UserTimeModel.fromJson(x))),
        likedByOther: json["likedByOther"] == null
            ? null
            : List<String>.from(json["likedByOther"].map((x) => x)),
    acceptedLikesByOther: json["acceptedLikesByOther"] == null
            ? null
            : List<String>.from(json["acceptedLikesByOther"].map((x) => x)),
        chatByMe: json["chatByMe"] == null
            ? null
            : List<String>.from(json["chatByMe"].map((x) => x)),
        isEdited: json["isEdited"] == null ? 0 : json["isEdited"],
        fcmToken: json["fcmToken"] == null ? '' : json["fcmToken"],
        userStatus: json["userStatus"] == null ? false : json["userStatus"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        isAvailable: json["isAvailable"] == null ? true : json["isAvailable"],
        isVerificationApplied: json["isVerificationApplied"] == null
            ? null
            : json["isVerificationApplied"],
      );

  Map<String, dynamic> toJson() => {
        "logInType": logInType == null ? null : logInType,
        "userId": userId == null ? null : userId,
        "userName": userName == null ? null : userName,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "emailAddress": emailAddress == null ? null : emailAddress,
        "gender": gender == null ? null : gender,
        "photos":
            photos == null ? null : List<dynamic>.from(photos!.map((x) => x)),
        "age": age == null ? null : age,
        "interest": interest == null ? null : interest,
        "cast": cast == null ? null : cast,
        "subCaste": subCaste == null ? null : subCaste,
        "religion": religion == null ? null : religion,
        "usageType": usageType == null ? null : usageType,
        "country": country == null ? null : country,
        "city": city == null ? null : city,
        "height": height == null ? null : height,
        "maritalStatus": maritalStatus == null ? null : maritalStatus,
        "smoke": smoke == null ? null : smoke,
        "drink": drink == null ? null : drink,
        "language": language == null
            ? null
            : List<dynamic>.from(language!.map((x) => x)),
        "education": education == null ? null : education,
        "occupation": occupation == null ? null : occupation,
        "aboutMe": aboutMe == null ? null : aboutMe,
        "isVerified": isVerified == null ? false : isVerified,
        "isPremiumUser": isPremiumUser == null ? false : isPremiumUser,
        "planExpiryDate": planExpiryDate == null ? null : planExpiryDate,
        "lastOnline":
            lastOnline == null ? DateTime.now().toIso8601String() : lastOnline,
        "userFilter": userFilter == null ? null : userFilter!.toJson(),
        "swipedIds": swipedIds == null
            ? null
            : List<dynamic>.from(swipedIds!.map((x) => x)),
        "blockedUser": blockedUser == null
            ? null
            : List<dynamic>.from(blockedUser!.map((x) => x)),
        "likedByMe": likedByMe == null
            ? null
            : List<dynamic>.from(likedByMe!.map((x) => x.toJson())),
        "rejectedByMe": rejectedByMe == null
            ? null
            : List<dynamic>.from(rejectedByMe!.map((x) => x.toJson())),
        "likedByOther": likedByOther == null
            ? null
            : List<dynamic>.from(likedByOther!.map((x) => x)),
        "acceptedLikesByOther": acceptedLikesByOther == null
            ? null
            : List<dynamic>.from(acceptedLikesByOther!.map((x) => x)),
        "chatByMe": chatByMe == null
            ? null
            : List<dynamic>.from(chatByMe!.map((x) => x)),
        "isEdited": isEdited == null ? 0 : isEdited,
        "fcmToken": fcmToken == null ? '' : fcmToken,
        "userStatus": userStatus,
        "location": location == null ? null : location!.toJson(),
        "isAvailable": isAvailable == null ? true : isAvailable,
        "isVerificationApplied":
            isVerificationApplied == null ? null : isVerificationApplied,
      };
}

class UserFilter {
  UserFilter({
    this.age,
    this.cast,
    this.subCaste,
    this.gender,
    this.country,
    this.city,
    this.height,
    this.religion,
    this.maritalStatus,
    this.smoke,
    this.drink,
    this.education,
    this.language,
    this.usageType,
  });

  String? age;
  List<String>? cast;
  String? subCaste;
  String? gender;
  List<String>? country;
  List<String>? city;
  String? height;
  List<String>? religion;
  List<String>? maritalStatus;
  List<String>? smoke;
  List<String>? drink;
  List<String>? education;
  List<String>? language;
  List<String>? usageType;

  factory UserFilter.fromJson(Map<String, dynamic> json) => UserFilter(
        age: json["age"],
        cast: json["cast"] == null
            ? null
            : List<String>.from(json["cast"].map((x) => x)),
        subCaste: json["subCaste"],
        gender: json["gender"],
        country: json["country"] == null
            ? null
            : List<String>.from(json["country"].map((x) => x)),
        city: json["city"] == null
            ? null
            : List<String>.from(json["city"].map((x) => x)),
        height: json["height"],
        religion: json["religion"] == null
            ? null
            : List<String>.from(json["religion"].map((x) => x)),
        maritalStatus: json["maritalStatus"] == null
            ? null
            : List<String>.from(json["maritalStatus"].map((x) => x)),
        smoke: json["smoke"] == null
            ? null
            : List<String>.from(json["smoke"].map((x) => x)),
        drink: json["drink"] == null
            ? null
            : List<String>.from(json["drink"].map((x) => x)),
        education: json["education"] == null
            ? null
            : List<String>.from(json["education"].map((x) => x)),
        language: json["language"] == null
            ? null
            : List<String>.from(json["language"].map((x) => x)),
        usageType: json["usageType"] == null
            ? null
            : List<String>.from(json["usageType"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "cast": cast == null ? null : List<dynamic>.from(cast!.map((x) => x)),
        "subCaste": subCaste,
        "gender": gender,
        "height": height,
        "country":
            country == null ? null : List<dynamic>.from(country!.map((x) => x)),
        "city": city == null ? null : List<dynamic>.from(city!.map((x) => x)),
        "religion": religion == null
            ? null
            : List<dynamic>.from(religion!.map((x) => x)),
        "maritalStatus": maritalStatus == null
            ? null
            : List<dynamic>.from(maritalStatus!.map((x) => x)),
        "smoke":
            smoke == null ? null : List<dynamic>.from(smoke!.map((x) => x)),
        "drink":
            drink == null ? null : List<dynamic>.from(drink!.map((x) => x)),
        "education": education == null
            ? null
            : List<dynamic>.from(education!.map((x) => x)),
        "language": language == null
            ? null
            : List<dynamic>.from(language!.map((x) => x)),
        "usageType": usageType == null
            ? null
            : List<dynamic>.from(usageType!.map((x) => x)),
      };
}

class UserTimeModel {
  UserTimeModel({
    this.userId,
    this.actionTime,
  });

  String? userId;
  DateTime? actionTime;

  factory UserTimeModel.fromJson(Map<String, dynamic> json) => UserTimeModel(
        userId: json["userId"],
        actionTime: DateTime.parse(json["actionTime"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "actionTime": actionTime!.toIso8601String(),
      };
}

class Location {
  Location({
    this.latitude,
    this.longitude,
  });

  num? latitude;
  num? longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
