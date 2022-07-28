// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_bottom_sheet.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_photo_viewer.dart';
import 'package:dating/widgets/app_swipe_card/card_buttons.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherUserProfile extends StatefulWidget {
  final UserModel? userModel;

  const OtherUserProfile({Key? key, @required this.userModel})
      : super(key: key);

  @override
  State<OtherUserProfile> createState() => OtherUserProfileState();
}

class OtherUserProfileState extends State<OtherUserProfile> {
  final EdgeInsetsGeometry cardMargin = const EdgeInsets.only(right: 12, left: 20);

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, child) {
        return SafeArea(
          child: Scaffold(
            appBar: buildAppBar(context, widget.userModel),
            body: Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0XFFF2F2F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AppImageAsset(
                            image: widget.userModel!.photos![0],
                            isWebImage: true,
                            webHeight:
                                MediaQuery.of(context).size.height / 1.26,
                            webWidth: MediaQuery.of(context).size.width,
                            webFit: BoxFit.cover,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Colors.black12.withOpacity(0),
                                    Colors.black12.withOpacity(.4),
                                    Colors.black12.withOpacity(.82),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppText(
                                      text: widget.userModel!.userName!
                                          .toTitleCase(),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(width: 10),
                                    if (widget.userModel!.isVerified)
                                      const AppImageAsset(
                                        image: ImageConstant.blueVerifyBadge,
                                        height: 18,
                                      )
                                  ],
                                ),
                                if (widget.userModel!.cast != null &&
                                    widget.userModel!.religion != null)
                                  AppText(
                                    text:
                                        '${widget.userModel!.cast} . ${widget.userModel!.religion}',
                                    fontSize: 18,
                                  ),
                                const SizedBox(height: CardButton.height - 30),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.userModel!.aboutMe != null &&
                        widget.userModel!.aboutMe!.isNotEmpty)
                      aboutMeView(widget.userModel!.aboutMe),
                    if (widget.userModel!.usageType != null &&
                        widget.userModel!.usageType!.isNotEmpty)
                      lookingForView(widget.userModel!.usageType),
                    const SizedBox(height: 20),
                    cardTitleText('Personal info'),
                    const SizedBox(height: 16),
                    buildPersonalInfo(widget.userModel!),
                    const SizedBox(height: 30),
                    CarouselSlider(
                      items: List.generate(
                        widget.userModel!.photos!.length,
                        (index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) =>
                                    AppPhotoViewer(
                                  photoViewerImages: widget.userModel!.photos!,
                                  selectedIndex: index,
                                ),
                              ),
                            );
                          },
                          child: AppImageAsset(
                            image: widget.userModel!.photos![index],
                            isWebImage: true,
                            webWidth: MediaQuery.of(context).size.width,
                            webHeight: MediaQuery.of(context).size.height / 3.0,
                            webFit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 3.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 1,
                      ),
                    ),
                    buildBottomNavBar(
                        context, widget.userModel!.userId, userProfileProvider),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const SizedBox(height: 60),
          ),
        );
      },
    );
  }

  Row buildBottomNavBar(BuildContext context, String? userId,
      UserProfileProvider userProfileProvider) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.only(top: 34, bottom: 14, left: 26),
            decoration: const BoxDecoration(
              color: ColorConstant.transparent,
            ),
            child: const AppText(
              text: 'Back',
              fontSize: 18,
              fontColor: ColorConstant.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => AppBottomSheet(
                currentIndex: 0,
                title: 'Block & Report',
                sheetData: blockReasonList,
                onPressed: () =>
                    blockUser(userId, userProfileProvider.currentUserId),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 34, bottom: 14, right: 26),
            decoration: const BoxDecoration(
              color: ColorConstant.transparent,
            ),
            child: const AppText(
              text: 'Block & Report',
              fontSize: 18,
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Wrap buildPersonalInfo(UserModel userModel) {
    return Wrap(
      spacing: -20,
      runSpacing: 20,
      children: [
        if (userModel.gender != null && userModel.gender!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.genderCardIcon,
            name: userModel.gender,
          ),
        if (userModel.age != null && userModel.age!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.birthdayCardIcon,
            name: dateFormatter(userModel.age),
          ),
        if (userModel.height != null && userModel.height!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.heightCardIcon,
            name: userModel.height,
          ),
        if (userModel.smoke != null && userModel.smoke!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.smokingCard,
            name: userModel.smoke,
          ),
        if (userModel.drink != null && userModel.drink!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.drinkingCard,
            name: userModel.drink,
          ),
        if (userModel.education != null && userModel.education!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.educationCard,
            name: userModel.education,
          ),
        if (userModel.occupation != null && userModel.occupation!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.jobCard,
            name: userModel.occupation,
          ),
        if (userModel.language != null && userModel.language!.isNotEmpty)
          buildPersonalInfoCard(
            image: ImageConstant.languageCard,
            name: userModel.language!.join(', '),
          ),
      ],
    );
  }

  Row buildPersonalInfoCard({@required String? image, @required String? name}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: cardMargin,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0XFFE1E1E1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              AppImageAsset(
                image: image,
                height: 16,
              ),
              const SizedBox(width: 8),
              AppText(
                text: name,
                fontColor: ColorConstant.black,
                fontSize: 16,
                letterSpacing: 0.48,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column lookingForView(String? usageType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        cardTitleText('Looking for'),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: cardMargin,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0XFFE1E1E1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: usageType,
                fontColor: ColorConstant.black,
                fontSize: 16,
                letterSpacing: 0.48,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding cardTitleText(String cardTitle) {
    return Padding(
      padding: cardMargin,
      child: AppText(
        text: cardTitle,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontColor: ColorConstant.pink,
      ),
    );
  }

  Column aboutMeView(String? aboutMe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        cardTitleText('About me'),
        const SizedBox(height: 4),
        Padding(
          padding: cardMargin,
          child: AppText(
            text: aboutMe,
            maxLines: 5,
            fontSize: 16,
            fontColor: ColorConstant.black,
          ),
        ),
      ],
    );
  }

  Future<void> blockUser(String? userId, String? currentUserId) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await UserService().addBlockList(context,
        currentUserId: currentUserId, blockUserId: userId);
    homeProvider.selectedBlockReason = -1;
    homeProvider.isDetails = false;
    homeProvider.notifyListeners();
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
                    builder: (context) => const HomeScreen(selectedIndex: 1)),
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

  PreferredSize buildAppBar(BuildContext context, UserModel? userModel) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height * 1.2),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const AppImageAsset(
                image: ImageConstant.circleBackIcon,
              ),
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.appLogo, height: 40),
            const Spacer(),
            const AppImageAsset(
              image: ImageConstant.circleBackIcon,
              color: ColorConstant.white,
            ),
          ],
        ),
      ),
    );
  }
}
