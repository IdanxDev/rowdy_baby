// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RejectedScreen extends StatefulWidget {
  const RejectedScreen({Key? key}) : super(key: key);

  @override
  State<RejectedScreen> createState() => RejectedScreenState();
}

class RejectedScreenState extends State<RejectedScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              primary: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 50),
              children: [
                const AppImageAsset(
                  image: 'assets/icons/red_close.svg',
                  height: 60,
                ),
                const SizedBox(height: 20),
                const AppText(
                  text: 'Your profile has not verified',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontColor: ColorConstant.pink,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: AppText(
                    text:
                        '- Take a clear selfie\n- Your profile photos are one of them and your selfie should match.',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontColor: ColorConstant.black,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 50),
                Consumer<UserProfileProvider>(
                  builder: (context, provider, child) {
                    return AppElevatedButton(
                      text: 'Get verified',
                      fontSize: 18,
                      buttonColor: ColorConstant.blue,
                      height: 54,
                      onPressed: () => getVerificationSelfie(provider.currentUserId),
                    );
                  },
                ),
              ],
            ),
            if (isLoading) const AppImageLoader()
          ],
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height),
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                color: ColorConstant.transparent,
                child: const AppImageAsset(image: ImageConstant.circleBackIcon),
              ),
            ),
            const AppText(
              text: 'Get verified',
              fontSize: 22,
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getVerificationSelfie(String? currentUserId) async {
    XFile? cameraImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);
    if (cameraImage != null) {
      setState(() => isLoading = true);
      Reference reference = FirebaseStorage.instance
          .ref('VerificationImages/${DateTime.now().toIso8601String()}');
      try {
        UploadTask uploadTask = reference.putFile(
          File(cameraImage.path),
          SettableMetadata(
              contentType: 'image/${cameraImage.path.split('.').last}'),
        );
        uploadTask.snapshotEvents.listen((event) {
          logs('uploadTask --> ${event.state.name}');
          double value = (event.bytesTransferred / event.totalBytes);
          logs('value --> $value');
        });
        uploadTask.whenComplete(() async {
          String imageUrl = await reference.getDownloadURL();
          logs('Camera images --> $imageUrl');
          setState(() => isLoading = false);
          Navigator.pop(context);
          UserService().updateProfile(context, currentUserId: currentUserId, key: 'isVerificationApplied', value: 'applied');
          showMessage(
            context,
            message: 'We received your selfie, You may get verified soon.!',
          );
        });
      } on FirebaseException catch (e) {
        logs('${e.code} : ${e.message} due to ${e.stackTrace}');
      }
    }
  }
}
