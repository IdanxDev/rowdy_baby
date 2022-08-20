// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/chat_module/admin_conversation_screen.dart';
import 'package:dating/screen/chat_module/chat_screen_view_model.dart';
import 'package:dating/screen/chat_module/conversation_screen/conversation_screen.dart';
import 'package:dating/screen/premium_screen/premium_bottom_sheet.dart';
import 'package:dating/service/admin_service.dart';
import 'package:dating/service/chat_service.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final EdgeInsetsGeometry padding = const EdgeInsets.only(left: 25, right: 25);
  ChatViewModel? chatViewModel;
  UserService userService = UserService();
  List<String> blockedUsers = <String>[];
  List<String> matchedUsers = <String>[];
  List<String> chattedUsers = <String>[];
  ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    chatViewModel ?? (chatViewModel = ChatViewModel(this));
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, child) {
        return SafeArea(
          child: Scaffold(
            body: userProfileProvider.isLoading
                ? const AppLoader()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: padding,
                        child: const AppText(
                          text: 'Your Matches',
                          fontColor: ColorConstant.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildMatchesView(userProfileProvider),
                      Padding(
                        padding: padding,
                        child: const AppText(
                          text: 'Messages',
                          fontColor: ColorConstant.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      StreamBuilder(
                        stream: AdminService.getAdminMessage(context),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(color: ColorConstant.transparent);
                          } else if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const SizedBox();
                            } else if (snapshot.hasData) {
                              return snapshot.data!.docs.isEmpty
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AdminConversationScreen(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        color: ColorConstant.transparent,
                                        padding: const EdgeInsets.symmetric(
                                                horizontal: 25)
                                            .copyWith(top: 20),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 32,
                                              backgroundColor:
                                                  ColorConstant.white,
                                              child: Container(
                                                height: 66,
                                                padding:
                                                    const EdgeInsets.all(14),
                                                decoration: const BoxDecoration(
                                                  color: ColorConstant.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ColorConstant
                                                          .dropShadow,
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                                child: const AppImageAsset(
                                                  image: ImageConstant.appIcon,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    AppText(
                                                      text: 'Rowdy baby',
                                                      fontSize: 16,
                                                      fontColor:
                                                          ColorConstant.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(width: 4),
                                                    AppImageAsset(
                                                      image: ImageConstant
                                                          .blueVerifyBadge,
                                                      height: 14,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                const AppText(
                                                  text: 'Team',
                                                  fontSize: 14,
                                                  fontColor:
                                                      ColorConstant.black,
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorConstant.pink,
                                              ),
                                              child: AppText(
                                                text:
                                                    '${snapshot.data!.docs.length}',
                                                fontSize: 10,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      buildMessageView(userProfileProvider),
                    ],
                  ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () async {
            //     final instance = FirebaseFirestore.instance;
            //     final batch = instance.batch();
            //     var coolection = instance.collection('conversation');
            //     var snapshot = await coolection.get();
            //     for (var doc in snapshot.docs) {
            //       if (doc.reference.id
            //           .contains('7jwxkrBu1yTnMSVzvCAptkZmJhN2')) {
            //         batch.delete(doc.reference);
            //       }
            //     }
            //     await batch.commit();
            //   },
            // ),
          ),
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildMessageView(
      UserProfileProvider userProfileProvider) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessagedUsers(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(color: ColorConstant.transparent);
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(
              child: AppText(
                text: 'Something went wrong',
                fontColor: ColorConstant.pink,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? const SizedBox()
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 25)
                          .copyWith(top: 20),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        bool isUser = snapshot.data!.docs[index].id
                            .contains(userProfileProvider.currentUserId!);
                        List<String> chatId =
                            snapshot.data!.docs[index].id.split('-');
                        chatId.remove(userProfileProvider.currentUserId);
                        if (!isUser) {
                          return const SizedBox();
                        }
                        return StreamBuilder<DocumentSnapshot<Object?>>(
                          stream: userService.getCurrentUserSnap(context,
                              userId: chatId[0]),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot<Object?>>
                                  userSnapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  color: ColorConstant.transparent);
                            } else if (snapshot.connectionState ==
                                    ConnectionState.active ||
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: AppText(
                                    text: 'Something went wrong',
                                    fontColor: ColorConstant.pink,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                return (snapshot.data == null ||
                                        userSnapshot.data == null)
                                    ? Container()
                                    : buildUserView(
                                        userSnapshot, userProfileProvider);
                              } else {
                                return const AppText(
                                  text: 'No Messages',
                                  fontColor: ColorConstant.pink,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                );
                              }
                            } else {
                              return Center(
                                child: Text(
                                  snapshot.connectionState.name,
                                  style: const TextStyle(
                                    color: ColorConstant.white,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
          } else {
            return const AppText(
              text: 'No Messages',
              fontColor: ColorConstant.pink,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            );
          }
        } else {
          return Center(
            child: Text(
              snapshot.connectionState.name,
              style: const TextStyle(
                color: ColorConstant.white,
                fontSize: 20,
              ),
            ),
          );
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildMatchesView(
      UserProfileProvider provider) {
    return StreamBuilder<QuerySnapshot>(
      stream: userService.getUsers(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Container(color: ColorConstant.transparent);
        } else if (userSnapshot.connectionState == ConnectionState.active ||
            userSnapshot.connectionState == ConnectionState.done) {
          if (userSnapshot.hasError) {
            return const Center(
              child: AppText(
                text: 'Something went wrong',
                fontColor: ColorConstant.pink,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          } else if (userSnapshot.hasData) {
            return userSnapshot.data!.docs.isEmpty
                ? buildRowdyMatchAvatar(context)
                : buildMatchesCircleAvatar(userSnapshot, provider);
          } else {
            return const AppText(
              text: 'No Messages',
              fontColor: ColorConstant.pink,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            );
          }
        } else {
          return Center(
            child: Text(
              userSnapshot.connectionState.name,
              style: const TextStyle(
                color: ColorConstant.white,
                fontSize: 20,
              ),
            ),
          );
        }
      },
    );
  }

  Stack buildMatchesCircleAvatar(
      AsyncSnapshot<QuerySnapshot<Object?>> userSnapshot,
      UserProfileProvider provider) {
    return Stack(
      children: [
        buildRowdyMatchAvatar(context),
        Container(
          color: ColorConstant.themeScaffold,
          height: 120,
          child: ListView.separated(
            itemCount: userSnapshot.data!.docs.length,
            shrinkWrap: true,
            padding: padding,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              UserModel userModel = UserModel.fromJson(
                  userSnapshot.data!.docs[index].data() as Map<String, dynamic>);
              if (userModel.userId == provider.currentUserId ||
                  !blockedUsers.contains(userModel.userId) ||
                  !matchedUsers.contains(userModel.userId) ||
                  !provider.currentUserData!.acceptedLikesByOther!.contains(userModel.userId)) {
                return const SizedBox();
              }
              return GestureDetector(
                onTap: () => goToConversationScreen(provider, userModel),
                child: !userModel.isAvailable
                    ? const SizedBox()
                    : Container(
                        width: 66,
                        color: ColorConstant.white,
                        child: Column(
                          children: [
                            GFAvatar(
                              size: 50,
                              backgroundColor: ColorConstant.white,
                              backgroundImage: NetworkImage(
                                userModel.photos![0],
                              ),
                              child: userModel.userStatus == false
                                  ? const SizedBox()
                                  : GFIconBadge(
                                      padding: EdgeInsets.zero,
                                      counterChild: const GFBadge(
                                        color: Colors.green,
                                        text: '',
                                        size: 20,
                                        shape: GFBadgeShape.circle,
                                      ),
                                      position: GFBadgePosition.bottomEnd(
                                          end: -18, bottom: -12),
                                      child: GFIconButton(
                                        padding: EdgeInsets.zero,
                                        type: GFButtonType.transparent,
                                        onPressed: null,
                                        shape: GFIconButtonShape.square,
                                        icon: Container(),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 6),
                            AppText(
                              text: userModel.userName!.toTitleCase(),
                              fontColor: ColorConstant.black,
                            ),
                          ],
                        ),
                      ),
              );
            },
            separatorBuilder: (context, index) {
              UserModel userModel = UserModel.fromJson(
                  userSnapshot.data!.docs[index].data() as Map<String, dynamic>);
              if (userModel.userId == provider.currentUserId ||
                  !blockedUsers.contains(userModel.userId) ||
                  !matchedUsers.contains(userModel.userId) ||
                  !provider.currentUserData!.acceptedLikesByOther!.contains(userModel.userId)) {
                return const SizedBox();
              }

              return !userModel.isAvailable
                  ? const SizedBox()
                  : Container(width: 20,color: ColorConstant.white,);
            },
          ),
        ),
      ],
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildRowdyMatchAvatar(
      BuildContext context) {
    return StreamBuilder(
      stream: AdminService.getAdminMessage(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(color: ColorConstant.transparent);
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const SizedBox();
          } else if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminConversationScreen(),
                  ),
                );
              },
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(left: 25, bottom: 10),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstant.dropShadow,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: ColorConstant.white,
                        child: AppImageAsset(
                          image: 'assets/images/love_birds.svg',
                          height: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const AppText(
                      text: 'Get Matched',
                      fontColor: ColorConstant.black,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget chatRoom(String id, String senderId) {
    String groupId =
        senderId.hashCode <= id.hashCode ? '$senderId-$id' : '$id-$senderId';
    return StreamBuilder(
      stream:
          chatService.getMessageStatus(context, chatRoomId: groupId, id: id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(color: ColorConstant.transparent);
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const SizedBox();
          } else if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstant.pink,
                    ),
                    child: AppText(
                      text: '${snapshot.data!.docs.length}',
                      fontSize: 10,
                      textAlign: TextAlign.center,
                    ),
                  );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  goToConversationScreen(
      UserProfileProvider userProfileProvider, UserModel userModel) {
    if (!userProfileProvider.currentUserData!.isPremiumUser) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => const PremiumBottomSheet(),
        ),
      );
    } else {
      String chatRoomId = userProfileProvider.currentUserId.hashCode <=
              userModel.userId.hashCode
          ? '${userProfileProvider.currentUserId}-${userModel.userId}'
          : '${userModel.userId}-${userProfileProvider.currentUserId}';
      logs('ChatroomId --> $chatRoomId');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatroomId: chatRoomId,
            userModel: userModel,
          ),
        ),
      );
    }
  }

  GestureDetector buildUserView(
      AsyncSnapshot<DocumentSnapshot<Object?>>? userSnapshot,
      UserProfileProvider userProfileProvider) {
    UserModel? userModel;
    if (userSnapshot!.data!.data() != null) {
      userModel =
          UserModel.fromJson(userSnapshot.data!.data() as Map<String, dynamic>);
    }
    return GestureDetector(
      onTap: () {
        goToConversationScreen(userProfileProvider, userModel!);
      },
      child: (userModel == null || !userModel.isAvailable)
          ? const SizedBox()
          : Container(
              color: ColorConstant.transparent,
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: ColorConstant.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: AppImageAsset(
                        image: userModel.photos![0],
                        isWebImage: true,
                        webWidth: 150,
                        webHeight: 150,
                        webFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: userModel.userName!.toTitleCase(),
                            fontSize: 16,
                            fontColor: ColorConstant.black,
                            fontWeight: FontWeight.bold,
                          ),
                          if (userModel.isVerified) const SizedBox(width: 4),
                          if (userModel.isVerified)
                            const AppImageAsset(
                                image: ImageConstant.blueVerifyBadge,
                                height: 14),
                        ],
                      ),
                      if (userModel.cast != null && userModel.religion != null)
                        const SizedBox(height: 4),
                      if (userModel.cast != null && userModel.religion != null)
                        AppText(
                          text: '${userModel.cast} . ${userModel.religion}',
                          fontSize: 14,
                          fontColor: ColorConstant.black,
                        ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      chatRoom(userSnapshot.data!.id,
                          userProfileProvider.currentUserId!),
                      const AppText(
                        text: ' ',
                        fontColor: ColorConstant.grey,
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
