import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/model/profile_model.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';

class UserService {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(BuildContext context, UserModel userModel) async {
    try {
      await userCollection.doc(userModel.userId).set(userModel.toJson());
    } on FirebaseException catch (e) {
      showMessage(context, message: e.message, isError: true);
    }
  }

  Future<UserModel?> getCurrentUser(BuildContext context,
      {@required String? userId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await userCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userMap =
            documentSnapshot.data() as Map<String, dynamic>?;
        UserModel userData = UserModel.fromJson(userMap!);
        return userData;
      }
      return null;
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
      return null;
    }
  }

  Stream<DocumentSnapshot<Object?>>? getCurrentUserSnap(BuildContext context,
      {@required String? userId}) {
    try {
      Stream<DocumentSnapshot<Object?>> documentSnapshot =
          userCollection.doc(userId).snapshots();
      return documentSnapshot;
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
      return null;
    }
  }

  Future<ProfileModel?> getCurrentUserProfile(BuildContext context,
      {@required String? userId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await userCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? profileMap =
            documentSnapshot.data() as Map<String, dynamic>?;
        ProfileModel profileDatas = ProfileModel.fromJson(profileMap!);
        num count = getAnswerQuestionsLength(profileDatas);
        profileMap['profilePercentage'] = count.round();
        ProfileModel profileData = ProfileModel.fromJson(profileMap);
        return profileData;
      }
      return null;
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
      return null;
    }
  }

  Future<List<UserModel>?> getAllCardUsers(
      BuildContext context, bool showFilterData,
      {@required UserModel? currentUserData}) async {
    List<UserModel> userModelList = <UserModel>[];
    try {
      QuerySnapshot querySnapshot = await userCollection.get();
      bool showWomen = currentUserData!.interest!.contains('women');
      bool showAll = currentUserData.interest!.contains('everyone');
      for (QueryDocumentSnapshot element in querySnapshot.docs) {
        Map<String, dynamic>? userMap = element.data() as Map<String, dynamic>?;
        UserModel userData = UserModel.fromJson(userMap!);
        if (userData.userId != currentUserData.userId) {
          userModelList.add(userData);
        }
      }
      getBlockedFilterData(userModelList, currentUserData);
      if (!showFilterData && !showAll) {
        filterGenderData(userModelList, showWomen);
      }
      logs('User list of card users --> ${userModelList.length}');
      userModelList = await getUnSwipedList(userModelList, currentUserData);
      logs('User list of card users after swipe filter --> ${userModelList.length}');
      return showFilterData
          ? getFilterList(userModelList, currentUserData)
          : userModelList;
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
      return null;
    }
  }

  Future<List<UserModel>?> getAllUsers(BuildContext context,
      {bool showError = true}) async {
    List<UserModel> userModelList = <UserModel>[];
    try {
      QuerySnapshot querySnapshot = await userCollection.get();
      for (QueryDocumentSnapshot element in querySnapshot.docs) {
        Map<String, dynamic>? userMap = element.data() as Map<String, dynamic>?;
        UserModel userData = UserModel.fromJson(userMap!);
        userModelList.add(userData);
      }
      logs('User list of all users --> ${userModelList.length}');
      return userModelList;
    } on FirebaseException catch (e) {
      if (showError) showMessage(message: e.message, context, isError: true);
      return null;
    }
  }

  Future<void> addFilters(BuildContext context,
      {@required String? currentUserId,
      @required Map<String, dynamic>? filterMap}) async {
    logs('Filter map --> $filterMap');
    try {
      await userCollection.doc(currentUserId).update(
        {'userFilter': filterMap},
      );
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  List<UserModel> getBlockedFilterData(
      List<UserModel> userModelList, UserModel currentUserData) {
    if (currentUserData.blockedUser != null &&
        currentUserData.blockedUser!.isNotEmpty) {
      for (String blockUserId in currentUserData.blockedUser!) {
        userModelList.removeWhere((element) => element.userId == blockUserId);
      }
    }
    return userModelList;
  }

  Future<List<UserModel>> getMessagedFilterData(
      BuildContext context, UserModel currentUserData) async {
    List<UserModel> userModelList = <UserModel>[];
    if (currentUserData.chatByMe != null &&
        currentUserData.chatByMe!.isNotEmpty) {
      for (String chatUserId in currentUserData.chatByMe!) {
        UserModel? userModel =
            await getCurrentUser(context, userId: chatUserId);
        if (userModel != null && userModel.isAvailable) {
          userModelList.add(userModel);
        }
      }
    } else {
      userModelList.clear();
    }
    return userModelList;
  }

  List<UserModel> filterGenderData(
      List<UserModel> userModelList, bool showWomen) {
    showWomen
        ? userModelList.removeWhere((element) => element.gender == 'Male')
        : userModelList.removeWhere((element) => element.gender == 'Female');
    return userModelList;
  }

  List<UserModel> getFilterList(
      List<UserModel> userModelList, UserModel currentUserData) {
    if (currentUserData.userFilter != null) {
      if (currentUserData.userFilter!.gender != null) {
        userModelList = filterCheck(userModelList, currentUserData, 'gender');
      }
      if (currentUserData.userFilter!.age != null &&
          currentUserData.userFilter!.age!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'age');
      }
      if (currentUserData.userFilter!.country != null &&
          currentUserData.userFilter!.country!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'country');
      }
      if (currentUserData.userFilter!.city != null &&
          currentUserData.userFilter!.city!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'city');
      }
      if (currentUserData.userFilter!.height != null &&
          currentUserData.userFilter!.height!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'height');
      }
      if (currentUserData.userFilter!.cast != null &&
          currentUserData.userFilter!.cast!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'cast');
      }
      if (currentUserData.userFilter!.religion != null &&
          currentUserData.userFilter!.religion!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'religion');
      }
      if (currentUserData.userFilter!.subCaste != null &&
          currentUserData.userFilter!.subCaste!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'subcaste');
      }
      if (currentUserData.userFilter!.maritalStatus != null &&
          currentUserData.userFilter!.maritalStatus!.isNotEmpty) {
        userModelList =
            filterCheck(userModelList, currentUserData, 'maritalStatus');
      }
      if (currentUserData.userFilter!.smoke != null &&
          currentUserData.userFilter!.smoke!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'smoke');
      }
      if (currentUserData.userFilter!.drink != null &&
          currentUserData.userFilter!.drink!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'drink');
      }
      if (currentUserData.userFilter!.education != null &&
          currentUserData.userFilter!.education!.isNotEmpty) {
        userModelList =
            filterCheck(userModelList, currentUserData, 'education');
      }
      if (currentUserData.userFilter!.language != null &&
          currentUserData.userFilter!.language!.isNotEmpty) {
        userModelList = filterCheck(userModelList, currentUserData, 'language');
      }
      if (currentUserData.userFilter!.usageType != null &&
          currentUserData.userFilter!.usageType!.isNotEmpty) {
        userModelList =
            filterCheck(userModelList, currentUserData, 'usageType');
      }
    }
    return userModelList;
  }

  List<UserModel> filterCheck(List<UserModel> userModelList,
      UserModel currentUserData, String filterType) {
    userModelList = userModelList.where((otherUserData) {
      switch (filterType) {
        case 'gender':
          if (otherUserData.gender == currentUserData.userFilter!.gender) {
            return true;
          }
          break;
        case 'age':
          if (otherUserData.age != null && otherUserData.age!.isNotEmpty) {
            List<String> ages = currentUserData.userFilter!.age!.split('-');
            DateTime birthdate = DateTime.parse(otherUserData.age!);
            int currentAge = DateTime.now().year - birthdate.year;
            if (currentAge >= int.parse(ages[0]) &&
                currentAge <= int.parse(ages[1])) {
              return true;
            }
          }
          break;
        case 'country':
          if (otherUserData.country != null &&
              otherUserData.country!.isNotEmpty) {
            if (currentUserData.userFilter!.country!
                .contains(otherUserData.country)) {
              return true;
            }
          }
          break;
        case 'city':
          if (otherUserData.city != null && otherUserData.city!.isNotEmpty) {
            if (currentUserData.userFilter!.city!
                .contains(otherUserData.city)) {
              return true;
            }
          }
          break;
        case 'height':
          if (otherUserData.height != null &&
              otherUserData.height!.isNotEmpty) {
            String otherUserHeight = otherUserData.height!.split('\'')[0];
            List<String> currentUserHeight =
                currentUserData.userFilter!.height!.split('-');
            if (int.parse(otherUserHeight) >= int.parse(currentUserHeight[0]) &&
                int.parse(otherUserHeight) <= int.parse(currentUserHeight[1])) {
              return true;
            }
          }
          break;
        case 'cast':
          if (otherUserData.cast != null && otherUserData.cast!.isNotEmpty) {
            if (currentUserData.userFilter!.cast!.contains('Open to all')) {
              return true;
            } else if (currentUserData.userFilter!.cast!
                .contains(otherUserData.cast)) {
              return true;
            }
          }
          break;
        case 'religion':
          if (otherUserData.religion != null &&
              otherUserData.religion!.isNotEmpty) {
            if (currentUserData.userFilter!.religion!.contains('Open to all')) {
              return true;
            } else if (currentUserData.userFilter!.religion!
                .contains(otherUserData.religion)) {
              return true;
            }
          }
          break;
        case 'subcaste':
          if (otherUserData.subCaste != null &&
              otherUserData.subCaste!.isNotEmpty) {
            if (currentUserData.userFilter!.subCaste!.toLowerCase() ==
                otherUserData.subCaste!.toLowerCase()) {
              return true;
            }
          }
          break;
        case 'maritalStatus':
          if (otherUserData.maritalStatus != null &&
              otherUserData.maritalStatus!.isNotEmpty) {
            if (currentUserData.userFilter!.maritalStatus!
                .contains(otherUserData.maritalStatus)) {
              return true;
            }
          }
          break;
        case 'smoke':
          if (otherUserData.smoke != null && otherUserData.smoke!.isNotEmpty) {
            if (currentUserData.userFilter!.smoke!
                .contains(otherUserData.smoke)) {
              return true;
            }
          }
          break;
        case 'drink':
          if (otherUserData.drink != null && otherUserData.drink!.isNotEmpty) {
            if (currentUserData.userFilter!.drink!
                .contains(otherUserData.drink)) {
              return true;
            }
          }
          break;
        case 'education':
          if (otherUserData.education != null &&
              otherUserData.education!.isNotEmpty) {
            if (currentUserData.userFilter!.education!
                .contains(otherUserData.education)) {
              return true;
            }
          }
          break;
        case 'language':
          if (otherUserData.language != null &&
              otherUserData.language!.isNotEmpty) {
            if (currentUserData.userFilter!.language!
                .any((element) => otherUserData.language!.contains(element))) {
              return true;
            }
          }
          break;
        case 'usageType':
          if (otherUserData.usageType != null &&
              otherUserData.usageType!.isNotEmpty) {
            if (currentUserData.userFilter!.usageType!
                .contains(otherUserData.usageType)) {
              return true;
            }
          }
          break;
      }
      return false;
    }).toList();
    return userModelList;
  }

  Future<void> addBlockList(BuildContext context,
      {@required String? currentUserId, @required String? blockUserId}) async {
    try {
      await userCollection.doc(currentUserId).update(
        {
          'blockedUser': FieldValue.arrayUnion([blockUserId])
        },
      );
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  Future<void> addChatList(BuildContext context,
      {@required String? currentUserId, @required String? chatUserId}) async {
    try {
      await userCollection.doc(currentUserId).update(
        {
          'chatByMe': FieldValue.arrayUnion([chatUserId])
        },
      );
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  num getAnswerQuestionsLength(ProfileModel profileData) {
    num answerQuestion = 3;
    if (profileData.age != null && profileData.age!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.interest != null && profileData.interest!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.cast != null && profileData.cast!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.religion != null && profileData.religion!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.usageType != null && profileData.usageType!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.height != null && profileData.height!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.maritalStatus != null &&
        profileData.maritalStatus!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.smoke != null && profileData.smoke!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.drink != null && profileData.drink!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.language != null && profileData.language!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.education != null && profileData.education!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.occupation != null && profileData.occupation!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.aboutMe != null && profileData.aboutMe!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.phoneNumber != null &&
        profileData.phoneNumber!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.emailAddress != null &&
        profileData.emailAddress!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.subCaste != null && profileData.subCaste!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.country != null && profileData.country!.isNotEmpty) {
      answerQuestion++;
    }
    if (profileData.city != null && profileData.city!.isNotEmpty) {
      answerQuestion++;
    }
    answerQuestion = answerQuestion * 4.76;
    logs('Answered questions --> $answerQuestion');
    return answerQuestion;
  }

  Future<void> deleteUser(BuildContext context,
      {@required String? currentUserId}) async {
    try {
      UserModel? userModel = await getCurrentUser(context, userId: currentUserId);
      if (userModel != null && !userModel.isAvailable) {
        await userCollection.doc(currentUserId).delete();
      }
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  Future<void> removeUser(BuildContext context,
      {@required String? currentUserId}) async {
    try {
      await userCollection.doc(currentUserId).delete();
      await userCollection.doc(currentUserId).set(UserModel(userId: currentUserId).toJson());
      await userCollection.doc(currentUserId).update({'isAvailable': false});
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  Future<void> upgradeToPremium(BuildContext context,
      {@required String? currentUserId,
      @required String? planExpiryDate}) async {
    try {
      await userCollection.doc(currentUserId).update(
        {
          'isPremiumUser': true,
          'planExpiryDate': planExpiryDate,
        },
      );
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  Future<void> likeByMe(BuildContext context,
      {@required String? currentUserId, @required String? likedByMe}) async {
    try {
      bool likeByMeChecked = await checkContainsValue(currentUserId, likedByMe);
      if (!likeByMeChecked) {
        await userCollection.doc(currentUserId).update(
          {
            'likedByMe': FieldValue.arrayUnion([
              {
                'userId': likedByMe,
                'actionTime': DateTime.now().toIso8601String()
              }
            ]),
          },
        );
      }
      await userCollection.doc(likedByMe).update(
        {
          'likedByOther': FieldValue.arrayUnion([currentUserId]),
        },
      );
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  Future<void> swipedByMe(BuildContext context, {@required String? currentUserId, @required String? swipedByMe}) async {
    try {
      await userCollection.doc(currentUserId).update(
        {
          'swipedIds': FieldValue.arrayUnion([swipedByMe]),
        },
      );
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  Future<void> removeLikeByMe(BuildContext context,
      {@required String? currentUserId, @required String? likedByMe}) async {
    try {
      await userCollection.doc(currentUserId).update(
        {
          'likedByOther': FieldValue.arrayRemove([likedByMe])
        },
      );
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  Future<void> rejectedByMe(BuildContext context,
      {@required String? currentUserId, @required String? likedByMe}) async {
    try {
      bool rejectedByMeChecked =
          await checkRejectContainsValue(currentUserId, likedByMe);
      if (!rejectedByMeChecked) {
        await userCollection.doc(currentUserId).update(
          {
            'rejectedByMe': FieldValue.arrayUnion([
              {
                'userId': likedByMe,
                'actionTime': DateTime.now().toIso8601String()
              }
            ])
          },
        );
      }
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
    }
  }

  Future<void> updateProfile(BuildContext context,
      {@required String? currentUserId,
      @required String? key,
      @required dynamic value,
      bool showError = true,
      bool isList = false}) async {
    try {
      if (isList) {
        await userCollection.doc(currentUserId).update(
          {key!: FieldValue.arrayUnion(value)},
        );
      } else {
        await userCollection.doc(currentUserId).update(
          {
            key!: value,
          },
        );
      }
    } on FirebaseException catch (e) {
      if (showError) showMessage(message: e.message, context, isError: true);
    }
  }

  Stream<QuerySnapshot<Object?>>? getUsers(BuildContext context) {
    try {
      return userCollection.orderBy('lastOnline').snapshots();
    } on FirebaseException catch (e) {
      logs('Catch error in getUsers : ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }

  Stream<UserModel>? getUserStatus(BuildContext context,
      {@required String? userId}) {
    try {
      return userCollection.doc(userId).snapshots().map(
        (event) {
          return UserModel.fromJson(event.data() as Map<String, dynamic>);
        },
      );
    } on FirebaseException catch (e) {
      logs('Catch error in getUserStatus : ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }

  Future<bool> checkContainsValue(
      String? currentUserId, String? likedByMe) async {
    List<String> tmpList = [];
    await userCollection.doc(currentUserId).get().then((value) {
      Map<String, dynamic>? userData = value.data() as Map<String, dynamic>?;
      if (userData!.containsKey('likedByMe') &&
          userData['likedByMe'] != null &&
          userData['likedByMe'].isNotEmpty) {
        userData['likedByMe'].forEach((element) {
          tmpList.add(element['userId']);
        });
      }
    });
    return tmpList.contains(likedByMe);
  }

  Future<bool> checkRejectContainsValue(
      String? currentUserId, String? likedByMe) async {
    List<String> tmpList = [];
    await userCollection.doc(currentUserId).get().then((value) {
      Map<String, dynamic>? userData = value.data() as Map<String, dynamic>?;
      if (userData!.containsKey('rejectedByMe') &&
          userData['rejectedByMe'] != null &&
          userData['rejectedByMe'].isNotEmpty) {
        userData['rejectedByMe'].forEach((element) {
          tmpList.add(element['userId']);
        });
      }
    });
    return tmpList.contains(likedByMe);
  }

  Future<List<UserModel>> getUnSwipedList(List<UserModel> userModelList, UserModel currentUserData) async {
    logs('data --> ${userModelList.length}');
    if (currentUserData.swipedIds != null && currentUserData.swipedIds!.isNotEmpty) {
      return userModelList.where((otherUsers) {
        if (currentUserData.swipedIds!.contains(otherUsers.userId!)){
          logs('message --> ${otherUsers.userId}');
          return false;
        } else {
          return true;
        }
      }).toList();
    }
    return userModelList;
  }
}
