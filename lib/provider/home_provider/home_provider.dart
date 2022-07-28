// ignore_for_file: use_build_context_synchronously

import 'package:dating/model/user_model.dart';
import 'package:dating/provider/disposable_provider/disposable_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProvider extends DisposableProvider {
  bool isDetails = false;
  bool isCardCompleted = false;
  int? selectedBlockReason;
  List<UserModel>? userModelList = <UserModel>[];
  UserService userService = UserService();
  String? userPicture;
  bool showFilterCard = false;
  bool isLoading = true;

  void changeBlockReason(int index) {
    selectedBlockReason = index;
    notifyListeners();
  }

  Future<void> getAllUsers(BuildContext context, {bool isSwipe = false}) async {
    final userProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    await userProvider.getCurrentUserData(context);
    List<UserModel>? allUserModelList = await userService.getAllCardUsers(context, currentUserData: userProvider.currentUserData, showFilterCard);
    if (isSwipe) {
      userModelList!.clear();
    }
    for (UserModel userModel in allUserModelList!) {
      if (userModel.isAvailable) {
        userModelList!.add(userModel);
      }
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void disposeAllValues() {
    // TODO: implement disposeAllValues
  }

  @override
  void disposeValues() {
    isDetails = false;
    isCardCompleted = false;
    selectedBlockReason = null;
    userModelList = <UserModel>[];
    userPicture = null;
    showFilterCard = false;
    isLoading = true;
  }
}
