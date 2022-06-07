import 'dart:io';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/screen/person_details_module/person_details_screen.dart';
import 'package:dating/screen/profile_module/birth_day_screen.dart';
import 'package:dating/screen/profile_module/cast_screen.dart';
import 'package:dating/screen/profile_module/gender_screen.dart';
import 'package:dating/screen/profile_module/interest_screen.dart';
import 'package:dating/screen/profile_module/name_screen.dart';
import 'package:dating/screen/profile_module/religion_screen.dart';
import 'package:dating/screen/profile_module/usage_type_screen.dart';
import 'package:dating/screen/profile_module/user_photos_screen.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  List<Widget> profileList = [
    const NameScreen(),
    const GenderScreen(),
    const UserPhotoScreen(),
    const BirthDayScreen(),
    const InterestScreen(),
    const CastScreen(),
    const ReligionScreen(),
    const UsageTypeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<AppProvider>(
        builder: (context, AppProvider appProvider, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: ColorConstant.pink,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12)
                      .copyWith(top: 16),
                  child: StepProgressIndicator(
                    totalSteps: profileList.length,
                    currentStep: appProvider.selectedProfileIndex + 1,
                    size: 8,
                    padding: 0,
                    selectedColor: ColorConstant.yellow,
                    unselectedColor: ColorConstant.white,
                    roundedEdges: const Radius.circular(10),
                  ),
                ),
              ),
              body: ListView(
                primary: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 52),
                children: [
                  profileList[appProvider.selectedProfileIndex],
                ],
              ),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20)
                        .copyWith(top: 0, bottom: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (appProvider.selectedProfileIndex != 0)
                      GestureDetector(
                        onTap: () {
                          appProvider.selectedProfileIndex <
                                  profileList.length - 1
                              ? (appProvider.selectedProfileIndex == 1 ||
                                      appProvider.selectedProfileIndex == 2)
                                  ? appProvider.changeProfileScreen(
                                      appProvider.selectedProfileIndex - 1)
                                  : appProvider.changeProfileScreen(
                                      appProvider.selectedProfileIndex + 1)
                              : goToPersonDetailsScreen(appProvider);
                        },
                        child: Container(
                          color: ColorConstant.transparent,
                          padding: const EdgeInsets.only(left: 30),
                          child: AppText(
                            text: (appProvider.selectedProfileIndex == 1 ||
                                    appProvider.selectedProfileIndex == 2)
                                ? 'Back'
                                : 'Skip',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    const Spacer(),
                    fabView(appProvider),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding fabView(AppProvider appProvider) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FloatingActionButton(
        backgroundColor: ColorConstant.white,
        elevation: 0,
        onPressed: () => moveToNext(appProvider),
        child: const AppImageAsset(
          image: ImageConstant.forwardArrowIcon,
          height: 20,
          width: 20,
        ),
      ),
    );
  }

  void moveToNext(AppProvider appProvider) {
    bool isImageSelected = false;
    for (String element in appProvider.userPhotos) {
      if (element.isNotEmpty) {
        isImageSelected = true;
      }
    }
    (appProvider.selectedProfileIndex == 0 &&
            (appProvider.nameController.text.isEmpty ||
                appProvider.nameController.text.trim().isEmpty))
        ? showMessage(context, message: 'Name can\'t be empty', isError: true)
        : (appProvider.selectedProfileIndex == 0 &&
                !RegExp(r'^[a-zA-Z ]+$')
                    .hasMatch(appProvider.nameController.text))
            ? showMessage(context,
                message: 'Name should only contains alphabets', isError: true)
            : (appProvider.selectedProfileIndex == 1 &&
                    appProvider.selectedGender == -1)
                ? showMessage(context,
                    message: 'Please select gender', isError: true)
                : (appProvider.selectedProfileIndex == 2 && !isImageSelected)
                    ? showMessage(context,
                        message: 'Please at least one picture', isError: true)
                    : (appProvider.selectedProfileIndex == 4 &&
                            appProvider.selectedInterest == -1)
                        ? showMessage(context,
                            message: 'Please select interest', isError: true)
                        : (appProvider.selectedProfileIndex == 5 &&
                                appProvider.selectedCast == -1)
                            ? showMessage(context,
                                message: 'Please select Cast', isError: true)
                            : (appProvider.selectedProfileIndex == 6 &&
                                    appProvider.selectedRegion == -1)
                                ? showMessage(context,
                                    message: 'Please select religion',
                                    isError: true)
                                : (appProvider.selectedProfileIndex == 7 &&
                                        appProvider.selectedUsageType == -1)
                                    ? showMessage(context,
                                        message:
                                            'Please select why you use app',
                                        isError: true)
                                    : (appProvider.selectedProfileIndex == 3 &&
                                            appProvider.birthDate == null)
                                        ? showMessage(context,
                                            message: 'Please select birth date',
                                            isError: true)
                                        : appProvider.selectedProfileIndex <
                                                profileList.length - 1
                                            ? appProvider.changeProfileScreen(
                                                appProvider
                                                        .selectedProfileIndex +
                                                    1)
                                            : goToPersonDetailsScreen(
                                                appProvider);
  }

  void goToPersonDetailsScreen(AppProvider appProvider) {
    List<String> userPhotos = <String>[];
    for (int i = 0; i < appProvider.userPhotos.length; i++) {
      if (appProvider.userPhotos[i].isNotEmpty) {
        Reference reference = FirebaseStorage.instance.ref(
            '${appProvider.userModel.userId}/${DateTime.now().toIso8601String()}');
        try {
          UploadTask uploadTask = reference.putFile(
            File(appProvider.userPhotos[i]),
            SettableMetadata(
                contentType:
                    'image/${appProvider.userPhotos[0].split('.').last}'),
          );
          uploadTask.snapshotEvents.listen((event) {
            logs('uploadTask --> ${event.state.name}');
            double value = (event.bytesTransferred / event.totalBytes);
            logs('value --> $value');
          });
          uploadTask.whenComplete(() async {
            appProvider.userPhotos[i] = '';
            String imageUrl = await reference.getDownloadURL();
            userPhotos.add(imageUrl);
          });
        } on FirebaseException catch (e) {
          logs('${e.code} : ${e.message} due to ${e.stackTrace}');
        }
      }
    }
    appProvider.userModel.photos = userPhotos;
    logs('Provider --> ${appProvider.userModel.photos}');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PersonDetailsScreen()),
    );
  }
}
