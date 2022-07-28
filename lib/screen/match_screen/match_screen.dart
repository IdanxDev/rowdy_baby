import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/chat_module/conversation_screen/conversation_screen.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchScreen extends StatefulWidget {
  final UserModel? userModel;

  const MatchScreen({Key? key, @required this.userModel}) : super(key: key);

  @override
  State<MatchScreen> createState() => MatchScreenState();
}

class MatchScreenState extends State<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, child) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                const AppImageAsset(
                  image: ImageConstant.heartFullBack,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ListView(
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    buildMatchCardView(context, userProfileProvider),
                    const SizedBox(height: 20),
                    AppText(
                      text:
                          'It\'s a match, ${userProfileProvider.currentUserData!.userName}',
                      fontSize: 18,
                      fontColor: ColorConstant.pink,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const AppText(
                      text: 'Start a conversation with each other',
                      fontSize: 14,
                      fontColor: ColorConstant.black,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    AppElevatedButton(
                      text: 'Say hello',
                      fontSize: 18,
                      height: 50,
                      onPressed: () {
                        String chatRoomId = userProfileProvider
                                    .currentUserId.hashCode <=
                                widget.userModel!.userId.hashCode
                            ? '${userProfileProvider.currentUserId}-${widget.userModel!.userId}'
                            : '${widget.userModel!.userId}-${userProfileProvider.currentUserId}';
                        logs('ChatroomId --> $chatRoomId');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationScreen(
                              chatroomId: chatRoomId,
                              userModel: widget.userModel,
                              isLiked: true,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Consumer<AppProvider>(
                      builder: (context, appProvider, child) {
                        return AppElevatedButton(
                          text: 'Keep swiping',
                          fontSize: 18,
                          height: 50,
                          buttonColor: ColorConstant.yellow.withOpacity(0.2),
                          fontColor: ColorConstant.yellow,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Stack buildMatchCardView(
      BuildContext context, UserProfileProvider userProfileProvider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 70),
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(4 / 360),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.8,
                  width: 180,
                  margin: const EdgeInsets.only(top: 17, right: 16),
                  decoration: BoxDecoration(
                    color: ColorConstant.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AppImageAsset(
                      image: userProfileProvider.currentUserData!.photos![0],
                      isWebImage: true,
                    ),
                  ),
                ),
                const AppImageAsset(
                  image: 'assets/icons/yellow_heart.svg',
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 100, top: 160),
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-10 / 360),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.8,
                  width: 180,
                  margin: const EdgeInsets.only(bottom: 18, left: 14),
                  decoration: BoxDecoration(
                    color: ColorConstant.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AppImageAsset(
                      image: widget.userModel!.photos![0],
                      isWebImage: true,
                    ),
                  ),
                ),
                const AppImageAsset(
                  image: 'assets/icons/red_heart.svg',
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
