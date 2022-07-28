// ignore_for_file: invalid_use_of_protected_member, use_build_context_synchronously, invalid_use_of_visible_for_testing_member, unused_import

import 'package:dating/model/user_model.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/chat_module/chat_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:provider/provider.dart';

class ChatViewModel {
  final ChatScreenState chatScreenState;
  UserService userService = UserService();
  List<UserModel>? availableUsers = <UserModel>[];

  ChatViewModel(this.chatScreenState) {
    getUserList();
  }

  Future<void> getUserList() async {
    final userProfileProvider = Provider.of<UserProfileProvider>(
        chatScreenState.context,
        listen: false);
    userProfileProvider.isLoading = true;
    userProfileProvider.notifyListeners();
    bool isPremiumUser = userProfileProvider.currentUserData!.isPremiumUser;
    // if (isPremiumUser) {
    availableUsers = await userService.getAllUsers(chatScreenState.context);
    availableUsers = userService.getBlockedFilterData(
        availableUsers!, userProfileProvider.currentUserData!);
    for (UserModel element in availableUsers!) {
      chatScreenState.blockedUsers.add(element.userId!);
    }
    if (!isPremiumUser &&
        userProfileProvider.currentUserData!.likedByOther != null &&
        userProfileProvider.currentUserData!.likedByOther!.isNotEmpty) {
      for (String element
          in userProfileProvider.currentUserData!.likedByOther!) {
        chatScreenState.matchedUsers.add(element);
      }
    } else if (isPremiumUser) {
      for (UserModel element in availableUsers!) {
        chatScreenState.matchedUsers.add(element.userId!);
      }
    }
    availableUsers = await userService.getMessagedFilterData(
        chatScreenState.context, userProfileProvider.currentUserData!);
    for (UserModel element in availableUsers!) {
      chatScreenState.chattedUsers.add(element.userId!);
    }
    // } else if (!isPremiumUser &&
    //     userProfileProvider.currentUserData!.likedByOther != null &&
    //     userProfileProvider.currentUserData!.likedByOther!.isNotEmpty) {
    //   logs('Others --> ${userProfileProvider.currentUserData!.likedByOther}');
    //   for (String userId
    //       in userProfileProvider.currentUserData!.likedByOther!) {
    //     UserModel? userModel = await userService
    //         .getCurrentUser(chatScreenState.context, userId: userId);
    //     if (userModel != null &&
    //         userProfileProvider.currentUserId != userModel.userId) {
    //       availableUsers!.add(userModel);
    //     }
    //   }
    //   availableUsers = userService.getBlockedFilterData(
    //       availableUsers!, userProfileProvider.currentUserData!);
    //   for (UserModel element in availableUsers!) {
    //     chatScreenState.blockedUsers.add(element.userId!);
    //   }
    //   availableUsers = await userService.getMessagedFilterData(
    //       chatScreenState.context, userProfileProvider.currentUserData!);
    //   for (UserModel element in availableUsers!) {
    //     chatScreenState.chattedUsers.add(element.userId!);
    //   }
    // }
    userProfileProvider.isLoading = false;
    userProfileProvider.notifyListeners();
    chatScreenState.setState(() {});
  }
}
