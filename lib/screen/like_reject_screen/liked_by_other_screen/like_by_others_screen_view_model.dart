// ignore_for_file: invalid_use_of_protected_member

import 'package:dating/model/user_model.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/like_reject_screen/liked_by_other_screen/liked_by_other_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:provider/provider.dart';

class LikeByOthersScreenViewModel {
  final LikedByOtherScreenState? likeByOthersScreenState;
  UserService userService = UserService();
  List<UserModel> likedByOtherList = <UserModel>[];

  LikeByOthersScreenViewModel(this.likeByOthersScreenState) {
    getUsers();
  }

  Future<void> getUsers() async {
    final userProfileProvider = Provider.of<UserProfileProvider>(
        likeByOthersScreenState!.context,
        listen: false);
    await userProfileProvider
        .getCurrentUserData(likeByOthersScreenState!.context);
    if (userProfileProvider.currentUserData!.likedByOther != null &&
        userProfileProvider.currentUserData!.likedByOther!.isNotEmpty) {
      logs('Others --> ${userProfileProvider.currentUserData!.likedByOther}');
      likedByOtherList.clear();
      for (String userId
          in userProfileProvider.currentUserData!.likedByOther!) {
        UserModel? userModel = await userService
            .getCurrentUser(likeByOthersScreenState!.context, userId: userId);
        if (userModel != null && userModel.isAvailable) {
          likedByOtherList.add(userModel);
        }
      }
      if (likedByOtherList.isNotEmpty) {
        likedByOtherList.insert(1, UserModel());
      }
    } else {
      likedByOtherList.clear();
    }
    if (likeByOthersScreenState!.mounted) {
      likeByOthersScreenState!.setState(() {
        likeByOthersScreenState!.isLoading = false;
      });
    }
  }
}
