// ignore_for_file: use_build_context_synchronously, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/screen/person_details_module/person_details_screen.dart';
import 'package:dating/screen/profile_module/birth_day_screen.dart';
import 'package:dating/screen/profile_module/cast_screen.dart';
import 'package:dating/screen/profile_module/gender_screen.dart';
import 'package:dating/screen/profile_module/interest_screen.dart';
import 'package:dating/screen/profile_module/name_screen.dart';
import 'package:dating/screen/profile_module/religion_screen.dart';
import 'package:dating/screen/profile_module/sub_cast_screen.dart';
import 'package:dating/screen/profile_module/usage_type_screen.dart';
import 'package:dating/screen/profile_module/user_photos_screen.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final bool isEdit;

  const ProfileScreen({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  List<Widget> profileList = [];

  @override
  void initState() {
    super.initState();
    Provider.of<LocalDataProvider>(context, listen: false).getCountries(context);
    profileList = [
      const NameScreen(),
      GenderScreen(isEdit: widget.isEdit),
      const UserPhotoScreen(),
      const BirthDayScreen(),
      InterestScreen(isEdit: widget.isEdit),
      CastScreen(isEdit: widget.isEdit),
      const SubCastScreen(),
      ReligionScreen(isEdit: widget.isEdit),
      UsageTypeScreen(isEdit: widget.isEdit),
    ];
  }

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
                preferredSize: Size.fromHeight(
                  (appProvider.isLoading || appProvider.isImageLoading)
                      ? 0
                      : AppBar().preferredSize.height,
                ),
                child: widget.isEdit
                    ? InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12)
                              .copyWith(top: 16),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: AppImageAsset(
                              image: ImageConstant.circleBackIcon,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12)
                            .copyWith(top: 16),
                        child: StepProgressIndicator(
                          totalSteps: profileList.length,
                          currentStep: appProvider.selectedProfileIndex + 1,
                          size: 9,
                          padding: 0,
                          selectedColor: ColorConstant.lightYellow,
                          unselectedColor: ColorConstant.white,
                          roundedEdges: const Radius.circular(10),
                        ),
                      ),
              ),
              body: Stack(
                children: [
                  ListView(
                    primary: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 52),
                    children: [
                      profileList[appProvider.selectedProfileIndex],
                    ],
                  ),
                  appProvider.isLoading ? const AppLoader() : const SizedBox(),
                  appProvider.isImageLoading
                      ? const AppImageLoader()
                      : const SizedBox(),
                ],
              ),
              floatingActionButton:
                  (widget.isEdit && appProvider.selectedProfileIndex == 6)
                      ? FloatingActionButton(
                          onPressed: () => Navigator.pop(
                              context, appProvider.subCasteController.text),
                          backgroundColor: ColorConstant.white,
                          child: const Icon(
                            Icons.done,
                            color: ColorConstant.pink,
                          ),
                        )
                      : const SizedBox(),
              bottomNavigationBar: (widget.isEdit ||
                      appProvider.isLoading ||
                      appProvider.isImageLoading)
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 20)
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
                                            appProvider.selectedProfileIndex ==
                                                2 ||
                                            appProvider.selectedProfileIndex ==
                                                4)
                                        ? appProvider.changeProfileScreen(
                                            appProvider.selectedProfileIndex -
                                                1)
                                        : appProvider.changeProfileScreen(
                                            appProvider.selectedProfileIndex +
                                                1)
                                    : goToPersonDetailsScreen(appProvider);
                              },
                              child: Container(
                                color: ColorConstant.transparent,
                                padding: const EdgeInsets.only(left: 30),
                                child: AppText(
                                  text: (appProvider.selectedProfileIndex ==
                                              1 ||
                                          appProvider.selectedProfileIndex ==
                                              2 ||
                                          appProvider.selectedProfileIndex == 4)
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
                                    appProvider.subCasteController.text.isEmpty)
                                ? showMessage(context,
                                    message: 'Please write sub Cast',
                                    isError: true)
                                : (appProvider.selectedProfileIndex == 7 &&
                                        appProvider.selectedRegion == -1)
                                    ? showMessage(context,
                                        message: 'Please select religion',
                                        isError: true)
                                    : (appProvider.selectedProfileIndex == 8 &&
                                            appProvider.selectedUsageType == -1)
                                        ? showMessage(context,
                                            message:
                                                'Please select why you use app',
                                            isError: true)
                                        : (appProvider.selectedProfileIndex ==
                                                    3 &&
                                                appProvider.birthDate == null)
                                            ? showMessage(context,
                                                message:
                                                    'Please select birth date',
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

  Future<void> uploadPhotos(AppProvider appProvider) async {
    appProvider.isLoading = true;
    appProvider.notifyListeners();
    List<String> userPhotos = <String>[];
    for (int i = 0; i < appProvider.userPhotos.length; i++) {
      if (appProvider.userPhotos[i].isNotEmpty) {
        Reference reference = FirebaseStorage.instance.ref(
            '${appProvider.userModel.userId}/${DateTime.now().toIso8601String()}');
        try {
          UploadTask uploadTask = reference.putFile(
            File(appProvider.userPhotos[i]),
            SettableMetadata(contentType: 'image/${appProvider.userPhotos[i].split('.').last}'),
          );
          uploadTask.snapshotEvents.listen((event) {
            logs('uploadTask --> ${event.state.name}');
            double value = (event.bytesTransferred / event.totalBytes);
            logs('value --> $value');
          });
          uploadTask.whenComplete(() async {
            // appProvider.userPhotos[i] = '';
            String imageUrl = await reference.getDownloadURL();
            userPhotos.add(imageUrl);
          });
        } on FirebaseException catch (e) {
          logs('${e.code} : ${e.message} due to ${e.stackTrace}');
        }
      }
    }
    logs('Photos --> $userPhotos');
    for (String element in userPhotos) {
      if (element.trim().isNotEmpty) {
        appProvider.userModel.photos!.add(element);
      }
    }
    logs('Photos Provider --> ${appProvider.userModel.photos}');
    appProvider.isLoading = false;
    appProvider.notifyListeners();
  }

  Future<void> goToPersonDetailsScreen(AppProvider appProvider) async {
    List<String> result = [];
    for (String item in appProvider.userModel.photos!) {
      if (item.isNotEmpty) {
        result.add(item);
      }
    }
    appProvider.userModel.photos = result;
    await setPrefStringValue(
      savedProfileData,
      userModelToJson(appProvider.userModel),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PersonDetailsScreen()),
    );
  }
}
