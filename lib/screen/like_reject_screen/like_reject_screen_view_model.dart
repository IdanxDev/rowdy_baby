// ignore_for_file: invalid_use_of_protected_member

import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/like_reject_screen/like_reject_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:provider/provider.dart';

class LikeRejectScreenViewModel {
  final LikeRejectScreenState? likeRejectScreenState;
  UserService userService = UserService();
  List<UserModel> likedByMeList = <UserModel>[];
  List<UserModel> rejectedByMeList = <UserModel>[];
  List<UserModel> likedByOtherList = <UserModel>[];

  LikeRejectScreenViewModel(this.likeRejectScreenState) {
    getUsers();
  }

  Future<void> getUsers() async {
    final appProvider =
        Provider.of<AppProvider>(likeRejectScreenState!.context, listen: false);
    final userProfileProvider = Provider.of<UserProfileProvider>(
        likeRejectScreenState!.context,
        listen: false);
    await userProfileProvider
        .getCurrentUserData(likeRejectScreenState!.context);
    if (appProvider.selectedLikeType == 0 &&
        userProfileProvider.currentUserData!.likedByMe != null &&
        userProfileProvider.currentUserData!.likedByMe!.isNotEmpty) {
      logs('Liked --> ${userProfileProvider.currentUserData!.likedByMe}');
      userProfileProvider.currentUserData!.likedByMe!
          .sort((a, b) => a.actionTime!.compareTo(b.actionTime!));
      for (UserTimeModel userTimeModel
          in userProfileProvider.currentUserData!.likedByMe!) {
        UserModel? userModel = await userService.getCurrentUser(
            likeRejectScreenState!.context,
            userId: userTimeModel.userId);
        if (userModel != null && userModel.isAvailable) {
          likedByMeList.add(userModel);
        }
      }
    }
    if (appProvider.selectedLikeType == 1 &&
        userProfileProvider.currentUserData!.rejectedByMe != null &&
        userProfileProvider.currentUserData!.rejectedByMe!.isNotEmpty) {
      logs('Rejected --> ${userProfileProvider.currentUserData!.rejectedByMe}');
      for (UserTimeModel userTimeModel
          in userProfileProvider.currentUserData!.rejectedByMe!) {
        UserModel? userModel = await userService.getCurrentUser(
            likeRejectScreenState!.context,
            userId: userTimeModel.userId);
        if (userModel != null && userModel.isAvailable) {
          rejectedByMeList.add(userModel);
        }
      }
    }
    if (appProvider.selectedLikeType == 2 &&
        userProfileProvider.currentUserData!.likedByOther != null &&
        userProfileProvider.currentUserData!.likedByOther!.isNotEmpty) {
      logs('Others --> ${userProfileProvider.currentUserData!.likedByOther}');
      for (String userId
          in userProfileProvider.currentUserData!.likedByOther!) {
        UserModel? userModel = await userService
            .getCurrentUser(likeRejectScreenState!.context, userId: userId);
        if (userModel != null && userModel.isAvailable) {
          likedByOtherList.add(userModel);
        }
      }
    }
    likeRejectScreenState!.setState(() {
      likeRejectScreenState!.isLoading = false;
    });
  }
}
