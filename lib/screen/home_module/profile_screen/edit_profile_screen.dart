// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/person_details_module/person_details_screen.dart';
import 'package:dating/screen/profile_module/profile_screen.dart';
import 'package:dating/screen/user_contact_screen/user_contact_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<String> userPhotos = ['', '', '', '', '', ''];
  double scrollSpeedVariable = 5;
  UserService userService = UserService();
  bool isLoading = false;
  bool isImageLoading = false;
  bool isCastLoading = false;

  @override
  void initState() {
    getUserPhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer2<UserProfileProvider, AppProvider>(
      builder: (context, userProfileProvider, appProvider, _) {
        return SafeArea(
          child: Scaffold(
            appBar: buildAppBar(userProfileProvider, appProvider),
            body: Stack(
              children: [
                ListView(
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20),
                  children: [
                    buildPhotoView(appProvider, userProfileProvider),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.only(right: 18, left: 32),
                      child: AppText(
                        text: 'Hold and drag photos to change their order, your first photo is your profile photo',
                        fontColor: ColorConstant.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.36,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.only(right: 18, left: 32),
                      child: AppText(
                        text: 'Personal details',
                        fontColor: ColorConstant.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (userProfileProvider.currentUserData!.logInType ==
                        'social')
                      const SizedBox(height: 22),
                    if (userProfileProvider.currentUserData!.logInType ==
                        'social')
                      buildPhoneView(userProfileProvider, appProvider),
                    if (userProfileProvider.currentUserData!.logInType ==
                        'phone')
                      const SizedBox(height: 22),
                    if (userProfileProvider.currentUserData!.logInType ==
                        'phone')
                      buildEmailView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildGenderView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildInterestView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildAgeView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildReligionView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildCastView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildSubCastView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildUsageTypeView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildCountryView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildCityView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildHeightView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildMaritalStatusView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildSmokeView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildDrinkView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildLanguageView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildEducationView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildJobView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                    buildAboutView(userProfileProvider, appProvider),
                    const SizedBox(height: 22),
                  ],
                ),
                isLoading
                    ? const AppImageLoader(loadingText: 'Updating your profile')
                    : const SizedBox(),
                isImageLoading ? const AppImageLoader() : const SizedBox(),
                isCastLoading ? const AppImageLoader(loadingText: 'Fetching castes') : const SizedBox(),
              ],
            ),
            bottomNavigationBar: (isLoading || isImageLoading)
                ? const SizedBox()
                : Container(
                    color: ColorConstant.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: AppElevatedButton(
                      text: 'Save',
                      height: 50,
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      borderRadius: 10,
                      onPressed: () async {
                        await saveProfile(userProfileProvider, appProvider);
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }

  ReorderableGridView buildPhotoView(
      AppProvider appProvider, UserProfileProvider userProfileProvider) {
    return ReorderableGridView.count(
      shrinkWrap: true,
      childAspectRatio: 1.5 / 1.5,
      mainAxisSpacing: 20,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          final element = userPhotos.removeAt(oldIndex);
          userPhotos.insert(newIndex, element);
        });
      },
      crossAxisCount: 3,
      children: List.generate(
        6,
        (index) => Stack(
          key: ValueKey(index.toString()),
          children: [
            GestureDetector(
              onTap: () => selectImages(appProvider, index),
              child: Container(
                height: 150,
                width: 150,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: userPhotos[index].isNotEmpty
                        ? ColorConstant.orange
                        : ColorConstant.transparent,
                    width: 2,
                  ),
                  color: const Color(0xFFFFF3E6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: userPhotos[index].isEmpty
                    ? const AppImageAsset(
                        image: ImageConstant.plusSignIcon,
                        height: 20,
                        fit: BoxFit.cover,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: userPhotos[index].contains('http')
                            ? AppImageAsset(
                                image: userPhotos[index],
                                isWebImage: true,
                                webHeight: 150,
                                webWidth: 150,
                                webFit: BoxFit.cover,
                              )
                            : Image.file(
                                File(userPhotos[index]),
                                fit: BoxFit.fill,
                                height: 150,
                                width: 150,
                              ),
                      ),
              ),
            ),
            if (userPhotos[index].isNotEmpty)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    userPhotos.removeAt(index);
                    userPhotos.insert(index, '');
                    setState(() {});
                  },
                  child: const AppImageAsset(
                    image: ImageConstant.closeSignIcon,
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAboutView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    bool validate = (userProfileProvider.currentUserData!.aboutMe != null &&
        userProfileProvider.currentUserData!.aboutMe!.isNotEmpty);
    return GestureDetector(
      onTap: () => updateAboutUs(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'About me',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (validate) const SizedBox(height: 12),
                if (validate)
                  AppText(
                    text: userProfileProvider.currentUserData!.aboutMe,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildJobView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    bool validate = (userProfileProvider.currentUserData!.occupation != null &&
        userProfileProvider.currentUserData!.occupation!.isNotEmpty);
    return GestureDetector(
      onTap: () => updateJob(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Your job?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (validate) const SizedBox(height: 12),
                if (validate)
                  AppText(
                    text: userProfileProvider.currentUserData!.occupation,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildEducationView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    bool validate = (userProfileProvider.currentUserData!.education != null &&
        userProfileProvider.currentUserData!.education!.isNotEmpty);
    return GestureDetector(
      onTap: () => updateEducation(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your education?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (validate) const SizedBox(height: 12),
                if (validate)
                  AppText(
                    text: userProfileProvider.currentUserData!.education,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildLanguageView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    bool validate = (userProfileProvider.currentUserData!.language != null &&
        userProfileProvider.currentUserData!.language!.isNotEmpty);
    return GestureDetector(
      onTap: () => updateLanguage(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Languages speak?',
                    fontColor: ColorConstant.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  if (validate) const SizedBox(height: 12),
                  if (validate)
                    AppText(
                      text: userProfileProvider.currentUserData!.language!
                          .join(', '),
                      fontColor: ColorConstant.pink,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 5,
                    ),
                ],
              ),
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildDrinkView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    bool validate = (userProfileProvider.currentUserData!.drink != null &&
        userProfileProvider.currentUserData!.drink!.isNotEmpty);
    return GestureDetector(
      onTap: () => updateDrink(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Do you drink?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (validate) const SizedBox(height: 12),
                if (validate)
                  AppText(
                    text: userProfileProvider.currentUserData!.drink,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildSmokeView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    bool validate = (userProfileProvider.currentUserData!.smoke != null &&
        userProfileProvider.currentUserData!.smoke!.isNotEmpty);
    return GestureDetector(
      onTap: () => updateSmoke(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Do you smoke?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (validate) const SizedBox(height: 12),
                if (validate)
                  AppText(
                    text: userProfileProvider.currentUserData!.smoke,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildMaritalStatusView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    bool validate =
        (userProfileProvider.currentUserData!.maritalStatus != null &&
            userProfileProvider.currentUserData!.maritalStatus!.isNotEmpty);
    return GestureDetector(
      onTap: () => updateMaritalStatus(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Marital status',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (validate) const SizedBox(height: 12),
                if (validate)
                  AppText(
                    text: userProfileProvider.currentUserData!.maritalStatus,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildCountryView(UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateCountry(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding: const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your Country ?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.country != null &&
                    userProfileProvider.currentUserData!.country!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.country != null &&
                    userProfileProvider.currentUserData!.country!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.country,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildCityView(UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateCity(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding: const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your city ?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.city != null &&
                    userProfileProvider.currentUserData!.city!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.city != null &&
                    userProfileProvider.currentUserData!.city!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.city,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildHeightView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateHeight(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your height ?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.height != null &&
                    userProfileProvider.currentUserData!.height!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.height != null &&
                    userProfileProvider.currentUserData!.height!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.height,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildUsageTypeView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateUsageType(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Why you use rowdy baby?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.usageType != null &&
                    userProfileProvider.currentUserData!.usageType!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.usageType != null &&
                    userProfileProvider.currentUserData!.usageType!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.usageType,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildReligionView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateReligion(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your religion?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.religion != null &&
                    userProfileProvider.currentUserData!.religion!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.religion != null &&
                    userProfileProvider.currentUserData!.religion!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.religion,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildAgeView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => selectDate(appProvider, userProfileProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your BirthDate?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.age != null &&
                    userProfileProvider.currentUserData!.age!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.age != null &&
                    userProfileProvider.currentUserData!.age!.isNotEmpty)
                  AppText(
                    text:
                        dateFormatter(userProfileProvider.currentUserData!.age),
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildCastView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateCast(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your caste?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.cast != null &&
                    userProfileProvider.currentUserData!.cast!.isNotEmpty)
                  const AppText(
                    text: 'you can edit your caste only twice',
                    fontColor: ColorConstant.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                if (userProfileProvider.currentUserData!.cast != null &&
                    userProfileProvider.currentUserData!.cast!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.cast,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildSubCastView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateSubCast(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your sub caste?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.subCaste != null &&
                    userProfileProvider.currentUserData!.subCaste!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.subCaste != null &&
                    userProfileProvider.currentUserData!.subCaste!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.subCaste,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildPhoneView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updatePhone(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Phone number',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.phoneNumber != null &&
                    userProfileProvider
                        .currentUserData!.phoneNumber!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.phoneNumber != null &&
                    userProfileProvider
                        .currentUserData!.phoneNumber!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.phoneNumber,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildEmailView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateEmail(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Email Address',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.emailAddress != null &&
                    userProfileProvider
                        .currentUserData!.emailAddress!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.emailAddress != null &&
                    userProfileProvider
                        .currentUserData!.emailAddress!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.emailAddress,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildGenderView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateGender(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'What\'s your gender ?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.gender != null &&
                    userProfileProvider.currentUserData!.gender!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.gender != null &&
                    userProfileProvider.currentUserData!.gender!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.gender,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  GestureDetector buildInterestView(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return GestureDetector(
      onTap: () => updateInterest(userProfileProvider, appProvider),
      child: Container(
        color: ColorConstant.indicatorColor,
        padding:
            const EdgeInsets.only(right: 18, left: 32, top: 24, bottom: 24),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Who are you Interested in ?',
                  fontColor: ColorConstant.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (userProfileProvider.currentUserData!.interest != null &&
                    userProfileProvider.currentUserData!.interest!.isNotEmpty)
                  const SizedBox(height: 12),
                if (userProfileProvider.currentUserData!.interest != null &&
                    userProfileProvider.currentUserData!.interest!.isNotEmpty)
                  AppText(
                    text: userProfileProvider.currentUserData!.interest,
                    fontColor: ColorConstant.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.forwardIcon)
          ],
        ),
      ),
    );
  }

  PreferredSize buildAppBar(
      UserProfileProvider userProfileProvider, AppProvider appProvider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height * 1.2),
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
              text: 'Edit Profile',
              fontSize: 22,
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
            ),
            // const Spacer(),
            // GestureDetector(
            //   onTap: () async {
            //     await saveProfile(userProfileProvider, appProvider);
            //   },
            //   child: Container(
            //     color: ColorConstant.transparent,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            //     child: const AppText(
            //       text: 'Save',
            //       fontSize: 18,
            //       fontColor: ColorConstant.pink,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> updateEmail(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    String? emailAddress =
        userProfileProvider.currentUserData!.emailAddress ?? '';
    String newEmail = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserContactScreen(contactDetails: emailAddress),
      ),
    );
    await userService.updateProfile(
      context,
      currentUserId: userProfileProvider.currentUserId,
      key: 'emailAddress',
      value: newEmail,
    );
    await userProfileProvider.getCurrentUserData(context);
    await userProfileProvider.getCurrentUserProfile(context);
    setState(() {});
  }

  Future<void> updatePhone(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    String? phoneNumber =
        userProfileProvider.currentUserData!.phoneNumber ?? '';
    String newNumber = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserContactScreen(isPhone: true, contactDetails: phoneNumber),
      ),
    );
    await userService.updateProfile(
      context,
      currentUserId: userProfileProvider.currentUserId,
      key: 'phoneNumber',
      value: newNumber,
    );
    await userProfileProvider.getCurrentUserData(context);
    await userProfileProvider.getCurrentUserProfile(context);
    setState(() {});
  }

  Future<void> updateGender(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedProfileIndex = 1;
    appProvider.selectedGender = genderList.indexWhere(
        (element) => element == userProfileProvider.currentUserData!.gender);
    String? gender = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(isEdit: true),
      ),
    );
    userProfileProvider.isLoading = true;
    userProfileProvider.notifyListeners();
    if (gender != null && gender.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'gender',
        value: gender,
      );
      await userProfileProvider.getCurrentUserData(context);
      // await userProfileProvider.getCurrentUserProfile(context);
    }
    setState(() {});
  }

  Future<void> updateInterest(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedProfileIndex = 4;
    appProvider.selectedInterest = interestTypeList.indexWhere(
        (element) => element == userProfileProvider.currentUserData!.interest);
    String? interest = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(isEdit: true),
      ),
    );
    userProfileProvider.isLoading = true;
    userProfileProvider.notifyListeners();
    if (interest != null && interest.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'interest',
        value: interest,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateReligion(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedProfileIndex = 7;
    appProvider.selectedRegion = religionTypeList.indexWhere(
        (element) => element == userProfileProvider.currentUserData!.religion);
    String? religion = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(isEdit: true),
      ),
    );
    if (religion != null && religion.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'religion',
        value: religion,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateCast(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    setState(() => isCastLoading = true);
    if (userProfileProvider.currentUserData!.isEdited >= 2) {
      setState(() => isCastLoading = false);
      showMessage(context, message: 'Your edit limit is already exceed.!', isError: true);
    } else {
      appProvider.selectedProfileIndex = 5;
      appProvider.selectedCast = castTypeList.indexWhere(
          (element) => element == userProfileProvider.currentUserData!.cast);
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => isCastLoading = false);
      });
      String? cast = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(isEdit: true),
        ),
      );
      if (cast != null && cast.isNotEmpty) {
        await userService.updateProfile(
          context,
          currentUserId: userProfileProvider.currentUserId,
          key: 'cast',
          value: cast,
        );
        await userService.updateProfile(
          context,
          currentUserId: userProfileProvider.currentUserId,
          key: 'isEdited',
          value: userProfileProvider.currentUserData!.isEdited + 1,
        );
        await userProfileProvider.getCurrentUserData(context);
        await userProfileProvider.getCurrentUserProfile(context);
      }
    }
    setState(() {});
  }

  Future<void> updateSubCast(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedProfileIndex = 6;
    appProvider.subCasteController.text =
        userProfileProvider.currentUserData!.subCaste ?? '';
    String? subCaste = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(isEdit: true),
      ),
    );
    if (subCaste != null && subCaste.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'subCaste',
        value: subCaste,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateUsageType(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedProfileIndex = 8;
    appProvider.selectedUsageType = usageTypeLists.indexWhere(
        (element) => element == userProfileProvider.currentUserData!.usageType);
    String? usageType = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(isEdit: true),
      ),
    );
    if (usageType != null && usageType.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'usageType',
        value: usageType,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateCountry(UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 1;
    appProvider.countryController.text = userProfileProvider.currentUserData!.country ?? '';
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    await userService.updateProfile(
      context,
      currentUserId: userProfileProvider.currentUserId,
      key: 'country',
      value: appProvider.countryController.text,
    );
    await userProfileProvider.getCurrentUserData(context);
    setState(() {});
  }

  Future<void> updateCity(UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 2;
    appProvider.countryController.text = userProfileProvider.currentUserData!.country ?? '';
    appProvider.cityController.text = userProfileProvider.currentUserData!.city ?? '';
    await Provider.of<LocalDataProvider>(context,listen: false).getCities(context, appProvider.countryController.text);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    await userService.updateProfile(
      context,
      currentUserId: userProfileProvider.currentUserId,
      key: 'city',
      value: appProvider.cityController.text,
    );
    await userProfileProvider.getCurrentUserData(context);
    setState(() {});
  }

  Future<void> updateHeight(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 3;
    appProvider.selectedHeight = heightList.indexWhere(
        (element) => element == userProfileProvider.currentUserData!.height);
    String? height = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    if (height != null && height.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'height',
        value: height,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateMaritalStatus(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 4;
    appProvider.selectedMaritalStatus = maritalStatusList.indexWhere((element) {
      return element == userProfileProvider.currentUserData!.maritalStatus;
    });
    String? maritalStatus = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    if (maritalStatus != null && maritalStatus.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'maritalStatus',
        value: maritalStatus,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateSmoke(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 5;
    appProvider.selectedSmokingType = smokeList.indexWhere(
        (element) => element == userProfileProvider.currentUserData!.smoke);
    String? smoke = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    if (smoke != null && smoke.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'smoke',
        value: smoke,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateDrink(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 6;
    appProvider.selectedDrinking = drinkList.indexWhere(
        (element) => element == userProfileProvider.currentUserData!.drink);
    String? drink = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    if (drink != null && drink.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'drink',
        value: drink,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateLanguage(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 7;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    await userService.updateProfile(
      context,
      currentUserId: userProfileProvider.currentUserId,
      key: 'language',
      value: appProvider.userModel.language,
      isList: true,
    );
    await userProfileProvider.getCurrentUserData(context);
    await userProfileProvider.getCurrentUserProfile(context);
    setState(() {});
  }

  Future<void> updateEducation(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 8;
    appProvider.selectedEducation = educationList.indexWhere(
        (element) => element == userProfileProvider.currentUserData!.education);
    String? education = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    if (education != null && education.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'education',
        value: education,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateJob(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 9;
    appProvider.jobNameController.text =
        userProfileProvider.currentUserData!.occupation!;
    String? job = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    if (job != null && job.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'occupation',
        value: appProvider.userModel.occupation,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> updateAboutUs(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    appProvider.selectedPersonalIndex = 10;
    appProvider.aboutMeController.text =
        userProfileProvider.currentUserData!.aboutMe ?? '';
    String? aboutMe = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonDetailsScreen(isEdit: true),
      ),
    );
    if (aboutMe != null && aboutMe.isNotEmpty) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'aboutMe',
        value: appProvider.userModel.aboutMe,
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }

  Future<void> selectImages(AppProvider appProvider, int index) async {
    XFile? galleryImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    userPhotos.removeAt(index);
    userPhotos.insert(index, galleryImage!.path);
    setState(() {
      isImageLoading = true;
    });
    if (galleryImage != null) {
      Reference reference = FirebaseStorage.instance.ref(
          '${appProvider.userModel.userId}/${DateTime.now().toIso8601String()}');
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
          userPhotos.removeAt(index);
          String imageUrl = await reference.getDownloadURL();
          userPhotos.insert(index, imageUrl);
          setState(() {
            isImageLoading = false;
          });
        });
      } on FirebaseException catch (e) {
        logs('${e.code} : ${e.message} due to ${e.stackTrace}');
      }
      logs('User image from Gallery --> $userPhotos');
    }
  }

  Future<void> saveProfile(
      UserProfileProvider userProfileProvider, AppProvider appProvider) async {
    List<String> result = [];
    for (String item in userPhotos) {
      if (item.isNotEmpty) {
        result.add(item);
      }
    }
    if (result.isNotEmpty) {
      setState(() => isLoading = true);
      await uploadImageIfMissed(result, appProvider);
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'photos',
        value: result,
      );
      await userProfileProvider.getCurrentUserData(context);
      await getUserPhotos();
      userProfileProvider.notifyListeners();
      setState(() => isLoading = false);
      // Navigator.pop(context);
    } else {
      showMessage(context, message: 'You must add one picture.', isError: true);
    }
  }

  Future<void> getUserPhotos() async {
    userPhotos = ['', '', '', '', '', ''];
    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    for (int i = 0;
        i < userProfileProvider.currentUserData!.photos!.length;
        i++) {
      userPhotos.insert(i, userProfileProvider.currentUserData!.photos![i]);
    }
    await uploadImageIfMissed(userPhotos, appProvider);
  }

  Future<void> uploadImageIfMissed(
      List<String> result, AppProvider appProvider) async {
    for (int i = 0; i < result.length; i++) {
      if (result[i].contains('com.js.dating')) {
        Reference reference = FirebaseStorage.instance.ref(
            '${appProvider.userModel.userId}/${DateTime.now().toIso8601String()}');
        try {
          UploadTask uploadTask = reference.putFile(
            File(result[i]),
            SettableMetadata(contentType: 'image/${result[i].split('.').last}'),
          );
          uploadTask.snapshotEvents.listen((event) {
            logs('uploadTask --> ${event.state.name}');
            double value = (event.bytesTransferred / event.totalBytes);
            logs('value --> $value');
          });
          uploadTask.whenComplete(() async {
            userPhotos.removeAt(i);
            String imageUrl = await reference.getDownloadURL();
            userPhotos.insert(i, imageUrl);
          });
        } on FirebaseException catch (e) {
          logs('${e.code} : ${e.message} due to ${e.stackTrace}');
        }
      }
    }
  }

  Future selectDate(
      AppProvider appProvider, UserProfileProvider userProfileProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100, 1),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
      initialDate: appProvider.birthDate ??
          DateTime.now().subtract(const Duration(days: 6570)),
      helpText: 'Birth Date',
      confirmText: 'Okay',
      cancelText: 'Cancel',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: ColorConstant.white,
            colorScheme: const ColorScheme.light(
              primary: ColorConstant.pink,
              onSurface: ColorConstant.black,
            ),
            fontFamily: AppTheme.defaultFont,
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      await userService.updateProfile(
        context,
        currentUserId: userProfileProvider.currentUserId,
        key: 'age',
        value: picked.toIso8601String(),
      );
      await userProfileProvider.getCurrentUserData(context);
    }
    setState(() {});
  }
}
