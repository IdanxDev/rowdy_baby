// ignore_for_file: use_build_context_synchronously

import 'package:dating/model/profile_model.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/disposable_provider/disposable_provider.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileProvider extends DisposableProvider {
  bool isLoading = true;
  UserService userService = UserService();
  String? currentUserId;
  UserModel? currentUserData;
  ProfileModel? currentUserProfile;
  int interestGender = 1;

  Future<void> getCurrentUserData(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    currentUserData =
        await userService.getCurrentUser(context, userId: currentUserId);
    if (currentUserData!.interest != null &&
        currentUserData!.interest!.contains('women')) {
      interestGender = 1;
    }
    await getCurrentUserProfile(context);
    await updateToPremiumUser(context);
  }

  Future<void> getCurrentUserProfile(BuildContext context) async {
    currentUserProfile =
        await userService.getCurrentUserProfile(context, userId: currentUserId);
    logs('User Profile --> ${currentUserProfile!.toJson()}');
    logs('User Profile --> ${currentUserProfile!.profilePercentage}');
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateToPremiumUser(BuildContext context) async {
    if (!currentUserData!.isPremiumUser) {
      await userService.updateProfile(
        context,
        currentUserId: currentUserId,
        key: 'isPremiumUser',
        value: true,
      );
    }
  }

  @override
  void disposeAllValues() {
    // TODO: implement disposeAllValues
  }

  @override
  void disposeValues() {
    isLoading = true;
    userService = UserService();
    currentUserId;
    currentUserData;
    currentUserProfile;
    interestGender = 1;
  }
}
