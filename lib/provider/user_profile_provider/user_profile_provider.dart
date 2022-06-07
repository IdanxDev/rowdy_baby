import 'package:dating/model/user_model.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  UserService userService = UserService();
  String? currentUserId;
  UserModel? currentUserData;

  Future<void> getCurrentUserData(BuildContext context) async {
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    currentUserData =
        await userService.getCurrentUser(context, userId: currentUserId);
    logs('User data --> ${currentUserData!.toJson()}');
  }
}
