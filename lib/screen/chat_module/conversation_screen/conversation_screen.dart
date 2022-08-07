// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/chat_model.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/home_module/profile_screen/other_user_profile.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/service/chat_service.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_bottom_sheet.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_photo_viewer.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String? chatroomId;
  final UserModel? userModel;
  final bool isLiked;

  const ConversationScreen({
    Key? key,
    @required this.chatroomId,
    @required this.userModel,
    this.isLiked = false,
  }) : super(key: key);

  @override
  State<ConversationScreen> createState() => ConversationScreenState();
}

class ConversationScreenState extends State<ConversationScreen> {
  final ImagePicker imagePicker = ImagePicker();
  UserService userService = UserService();
  ChatService chatService = ChatService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer2<AppProvider, UserProfileProvider>(
        builder: (context, appProvider, userProfileProvider, child) {
          return SafeArea(
            child: Scaffold(
              appBar: buildAppBar(context, appProvider, userProfileProvider),
              body: Column(
                children: [
                  buildBodyView(context, userProfileProvider),
                  buildSendRowView(userProfileProvider, appProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded buildBodyView(
      BuildContext context, UserProfileProvider userProfileProvider) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: chatService.getConversationMessage(context,
            chatRoomId: widget.chatroomId),
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
                  ? buildNoMessageView()
                  : buildConversationView(snapshot, userProfileProvider);
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
      ),
    );
  }

  Center buildNoMessageView() {
    return Center(
      child: AppText(
        text:
            'Let\'s start chat with ${widget.userModel!.userName!.toCapitalized()}',
        fontColor: ColorConstant.pink,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  ListView buildConversationView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      UserProfileProvider userProfileProvider) {
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      controller: listScrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        bool isReceiver = snapshot.data!.docs[index]['receiverName'] ==
            widget.userModel!.userName;
        if (userProfileProvider.currentUserId !=
            snapshot.data!.docs[index]['senderId']) {
          chatService.readMessage(snapshot.data!.docs[index].id,
              snapshot.data!.docs[index]['receiverId'], widget.chatroomId!);
        }
        return buildMessageView(snapshot, index, isReceiver);
      },
    );
  }

  GestureDetector buildMessageView(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index,
      bool isReceiver) {
    return GestureDetector(
      onTap: () {
        if (snapshot.data!.docs[index]['messageType'] != 'text' &&
            snapshot.data!.docs[index]['message'].isNotEmpty) {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) => AppPhotoViewer(
                photoViewerImages: [snapshot.data!.docs[index]['message']],
                selectedIndex: index,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: snapshot.data!.docs[index]['messageType'] == 'text'
            ? BubbleNormal(
                text: snapshot.data!.docs[index]['message'],
                isSender: isReceiver,
                color:
                    isReceiver ? ColorConstant.pink : const Color(0xFFDCDCDC),
                tail: true,
                textStyle: TextStyle(
                  fontFamily: 'Pangram',
                  fontSize: 16,
                  color: isReceiver ? ColorConstant.white : ColorConstant.black,
                ),
              )
            : snapshot.data!.docs[index]['message'].isEmpty
                ? BubbleNormal(
                    text: 'Sending image...',
                    isSender: isReceiver,
                    color: isReceiver
                        ? ColorConstant.pink
                        : const Color(0xFFDCDCDC),
                    tail: true,
                    textStyle: TextStyle(
                      fontFamily: 'Pangram',
                      fontSize: 16,
                      color: isReceiver
                          ? ColorConstant.white
                          : ColorConstant.black,
                    ),
                  )
                : Container(
                    alignment: isReceiver
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        right: isReceiver
                            ? 14
                            : MediaQuery.of(context).size.width / 2,
                        left: isReceiver
                            ? MediaQuery.of(context).size.width / 2
                            : 14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data!.docs[index]['message'],
                        fit: BoxFit.contain,
                        placeholder: (context, url) => BubbleNormal(
                          text: '. . .',
                          isSender: isReceiver,
                          color: isReceiver
                              ? ColorConstant.pink
                              : const Color(0xFFDCDCDC),
                          tail: true,
                          textStyle: TextStyle(
                            fontFamily: 'Pangram',
                            fontSize: 16,
                            color: isReceiver
                                ? ColorConstant.white
                                : ColorConstant.black,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const AppImageAsset(
                          image: ImageConstant.userAvatar,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Row buildSendRowView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => sendImage(appProvider, userProfileProvider),
          child: Container(
            color: ColorConstant.transparent,
            padding: const EdgeInsets.only(left: 24, right: 10, bottom: 16),
            child: const AppImageAsset(
              image: ImageConstant.chatPlusIcon,
              height: 20,
              width: 20,
            ),
          ),
        ),
        buildTxtFieldView(userProfileProvider),
        GestureDetector(
          onTap: () {
            if (messageController.text.trim().isNotEmpty) {
              sendMessage(userProfileProvider, messageController.text);
              listScrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
          child: Container(
            color: ColorConstant.transparent,
            padding: const EdgeInsets.only(right: 24, left: 6, bottom: 16),
            child: const AppImageAsset(
              image: ImageConstant.chatSendIcon,
              height: 46,
              width: 34,
            ),
          ),
        ),
      ],
    );
  }

  Flexible buildTxtFieldView(UserProfileProvider userProfileProvider) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(color: ColorConstant.dropShadow, blurRadius: 4),
            ],
          ),
          child: TextFormField(
            controller: messageController,
            focusNode: focusNode,
            cursorColor: ColorConstant.pink,
            textInputAction: TextInputAction.done,
            maxLines: null,
            // autofocus: false,
            onFieldSubmitted: (message) {
              if (message.trim().isNotEmpty) {
                sendMessage(userProfileProvider, message);
                listScrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },
            decoration: InputDecoration(
              hintText: 'Type your message...',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0XFFA5A5A5),
                letterSpacing: 0.48,
              ),
              contentPadding: const EdgeInsets.fromLTRB(26, 6, 10, 6),
              filled: true,
              fillColor: ColorConstant.white,
              // fillColor: const Color(0XFFF2F2F2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: ColorConstant.transparent),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: ColorConstant.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: ColorConstant.transparent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                    const BorderSide(color: ColorConstant.red, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                    const BorderSide(color: ColorConstant.pink, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: ColorConstant.red.withOpacity(0.6),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context, AppProvider appProvider,
      UserProfileProvider userProfileProvider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height * 1.5),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant.themeScaffold,
          boxShadow: [
            BoxShadow(
              color: ColorConstant.dropShadow.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.isLiked
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(
                            selectedIndex: 2,
                          ),
                        ),
                      )
                    : Navigator.pop(context);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const HomeScreen(selectedIndex: 3),
                //   ),
                // );
                // await userProfileProvider.getCurrentUserData(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                color: ColorConstant.transparent,
                child: const AppImageAsset(
                  image: ImageConstant.backAndroidIcon,
                  height: 20,
                  color: ColorConstant.pink,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtherUserProfile(
                    userModel: widget.userModel,
                  ),
                ),
              ),
              child: Container(
                color: ColorConstant.transparent,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: ColorConstant.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: AppImageAsset(
                          image: widget.userModel!.photos![0],
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: widget.userModel!.userName!.toTitleCase(),
                          fontSize: 16,
                          fontColor: ColorConstant.black,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        buildUserStatus(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            PopupMenuButton(
              onSelected: (value) async {
                logs('value --> $value');
                if (value == 1) {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, _, __) => AppBottomSheet(
                        currentIndex: 0,
                        title: 'Block & Report',
                        sheetData: blockReasonList,
                        onPressed: () async {
                          blockUser(
                            widget.userModel!.userId,
                            userProfileProvider.currentUserId,
                          );
                          await chatService.clearChat(context,
                              groupId: widget.chatroomId!);
                        },
                      ),
                    ),
                  );
                } else if (value == 2) {
                  logs('message --> ${widget.chatroomId}');
                  FocusScope.of(context).requestFocus(FocusNode());
                  await chatService.clearChat(context,
                      groupId: widget.chatroomId!);
                }
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: AppText(
                    text: 'Report & Block',
                    fontColor: ColorConstant.pink,
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: AppText(
                    text: 'Clear chat',
                    fontColor: ColorConstant.pink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<UserModel> buildUserStatus(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream:
          userService.getUserStatus(context, userId: widget.userModel!.userId),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
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
            return Row(
              children: [
                if (snapshot.data!.userStatus)
                  const GFBadge(
                    color: ColorConstant.green,
                    text: '',
                    size: 20,
                    shape: GFBadgeShape.circle,
                  ),
                if (snapshot.data!.userStatus) const SizedBox(width: 4),
                AppText(
                  text: snapshot.data!.userStatus ? 'Online' : 'Just Now',
                  fontSize: 12,
                  fontColor: ColorConstant.grey,
                ),
              ],
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

  Future<void> sendMessage(
      UserProfileProvider userProfileProvider, String message,
      {String? messageType = 'text'}) async {
    messageController.clear();
    await chatService.sendMessage(
      context,
      chatRoomId: widget.chatroomId,
      chatModel: ChatModel(
        message: message,
        messageTime: DateTime.now(),
        messageType: messageType,
        receiverName: widget.userModel!.userName,
        senderName: userProfileProvider.currentUserData!.userName,
        groupId: widget.chatroomId,
        isRead: false,
        receiverId: widget.userModel!.userId,
        senderId: userProfileProvider.currentUserId,
      ),
      token: widget.userModel!.fcmToken,
    );
    await userService.addChatList(
      context,
      currentUserId: userProfileProvider.currentUserId,
      chatUserId: widget.userModel!.userId,
    );
    await userService.addChatList(
      context,
      currentUserId: widget.userModel!.userId,
      chatUserId: userProfileProvider.currentUserId,
    );
  }

  Future<void> sendImageMessage(
      UserProfileProvider userProfileProvider, String message, String fileName,
      {String? messageType = 'image'}) async {
    messageController.clear();
    await chatService.sendImage(
      context,
      chatRoomId: widget.chatroomId,
      fileName: fileName,
      chatModel: ChatModel(
        message: message,
        messageTime: DateTime.now(),
        messageType: messageType,
        receiverName: widget.userModel!.userName,
        senderName: userProfileProvider.currentUserData!.userName,
        groupId: widget.chatroomId,
        isRead: false,
        receiverId: widget.userModel!.userId,
        senderId: userProfileProvider.currentUserId,
      ),
      token: widget.userModel!.fcmToken,
    );
  }

  Future<void> updateImageMessage(
      UserProfileProvider userProfileProvider, String message, String fileName,
      {String? messageType = 'image'}) async {
    messageController.clear();
    await chatService.updateImage(
      context,
      chatRoomId: widget.chatroomId,
      fileName: fileName,
      chatModel: ChatModel(
        message: message,
        messageTime: DateTime.now(),
        messageType: messageType,
        receiverName: widget.userModel!.userName,
        senderName: userProfileProvider.currentUserData!.userName,
        groupId: widget.chatroomId,
        isRead: false,
        receiverId: widget.userModel!.userId,
        senderId: userProfileProvider.currentUserId,
      ),
    );
  }

  Future<void> blockUser(String? userId, String? currentUserId) async {
    await userService.addBlockList(context,
        currentUserId: currentUserId, blockUserId: userId);
    await chatService.clearChat(context, groupId: widget.chatroomId!);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const AppText(
          text: 'Block & Report Successfully',
          fontSize: 18,
          fontColor: ColorConstant.pink,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppText(
              text:
                  'They won\'t know that you\'ve blocked or reported of them. Thanks for your feedback',
              fontSize: 14,
              fontColor: ColorConstant.black,
              fontWeight: FontWeight.w400,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(selectedIndex: 3)),
                (route) => false,
              ),
              child: AppText(
                text: 'Okay'.toUpperCase(),
                fontSize: 18,
                fontColor: ColorConstant.pink,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendImage(
      AppProvider appProvider, UserProfileProvider userProfileProvider) async {
    XFile? galleryImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (galleryImage != null) {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      sendImageMessage(userProfileProvider, '', fileName);
      Reference reference = FirebaseStorage.instance
          .ref('${appProvider.userModel.userId}/message/$fileName');
      try {
        UploadTask uploadTask = reference.putFile(
          File(galleryImage.path),
          SettableMetadata(
              contentType: 'image/${galleryImage.path.split('.').last}'),
        );
        uploadTask.snapshotEvents.listen((event) {
          logs('uploadTask --> ${event.state.name}');
          double value = (event.bytesTransferred / event.totalBytes);
          logs('value --> $value');
        });
        uploadTask.whenComplete(() async {
          String imageUrl = await reference.getDownloadURL();
          sendImageMessage(userProfileProvider, imageUrl, fileName);
        });
      } on FirebaseException catch (e) {
        logs('${e.code} : ${e.message} due to ${e.stackTrace}');
      }
      await userService.addChatList(
        context,
        currentUserId: userProfileProvider.currentUserId,
        chatUserId: widget.userModel!.userId,
      );
      await userService.addChatList(
        context,
        currentUserId: widget.userModel!.userId,
        chatUserId: userProfileProvider.currentUserId,
      );
    }
  }
}
