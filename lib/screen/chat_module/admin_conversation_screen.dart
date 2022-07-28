import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/service/admin_service.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_photo_viewer.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AdminConversationScreen extends StatelessWidget {
  final ScrollController listScrollController = ScrollController();
  AdminConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: AdminService.getAdminMessage(context),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(color: ColorConstant.transparent);
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
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
                          : ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        controller: listScrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return buildMessageView(snapshot, index, true,context);
                        },
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
              ),
            ),
            // buildSendRow(),
          ],
        ),
      ),
    );
  }

  GestureDetector buildMessageView(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index,
      bool isReceiver, BuildContext context) {
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

  Row buildSendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: ColorConstant.transparent,
          padding: const EdgeInsets.only(left: 24, right: 10, bottom: 16),
          child: const AppImageAsset(
            image: ImageConstant.chatPlusIcon,
            height: 20,
            width: 20,
          ),
        ),
        buildTxtFieldView(),
        Container(
          color: ColorConstant.transparent,
          padding: const EdgeInsets.only(right: 24, left: 6, bottom: 16),
          child: const AppImageAsset(
            image: ImageConstant.chatSendIcon,
            height: 46,
            width: 34,
          ),
        ),
      ],
    );
  }

  Flexible buildTxtFieldView() {
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
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'You can\'t send message...',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0XFFA5A5A5),
                letterSpacing: 0.48,
              ),
              filled: true,
              fillColor: ColorConstant.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: ColorConstant.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: ColorConstant.transparent),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height * 1.3),
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
              onTap: () => Navigator.pop(context),
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
            Container(
              color: ColorConstant.transparent,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: ColorConstant.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: const AppImageAsset(image: ImageConstant.appIcon),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      AppText(
                        text: 'Rowdy baby',
                        fontSize: 16,
                        fontColor: ColorConstant.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
