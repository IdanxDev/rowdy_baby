// ignore_for_file: use_build_context_synchronously

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/logIn_screen/login_screen.dart';
import 'package:dating/screen/person_details_module/about_me_screen.dart';
import 'package:dating/screen/person_details_module/city_screen.dart';
import 'package:dating/screen/person_details_module/country_screen.dart';
import 'package:dating/screen/person_details_module/detail_screen.dart';
import 'package:dating/screen/person_details_module/drink_screen.dart';
import 'package:dating/screen/person_details_module/education_screen.dart';
import 'package:dating/screen/person_details_module/height_screen.dart';
import 'package:dating/screen/person_details_module/job_screen.dart';
import 'package:dating/screen/person_details_module/language_screen.dart';
import 'package:dating/screen/person_details_module/marital_status_screen.dart';
import 'package:dating/screen/person_details_module/smoke_screen.dart';
import 'package:dating/service/auth_service.dart';
import 'package:dating/service/notification_service.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class PersonDetailsScreen extends StatefulWidget {
  final String? userModel;
  final bool isEdit;

  const PersonDetailsScreen({Key? key, this.userModel, this.isEdit = false})
      : super(key: key);

  @override
  State<PersonDetailsScreen> createState() => PersonDetailsScreenState();
}

class PersonDetailsScreenState extends State<PersonDetailsScreen> {
  NotificationService notificationService = NotificationService();
  UserService userService = UserService();
  List<Widget> personDetailsList = [];
  bool isLoading = false;

  @override
  void initState() {
    Provider.of<LocalDataProvider>(context, listen: false).getCountries(context);
    personDetailsList = [
      const DetailScreen(),
      const CountryListScreen(),
      const CityListScreen(),
      HeightScreen(isEdit: widget.isEdit),
      MaritalStatusScreen(isEdit: widget.isEdit),
      SmokeScreen(isEdit: widget.isEdit),
      DrinkScreen(isEdit: widget.isEdit),
      LanguageScreen(isEdit: widget.isEdit),
      EducationScreen(isEdit: widget.isEdit),
      JobScreen(isEdit: widget.isEdit),
      const AboutMeScreen(),
    ];
    if (!widget.isEdit) setPrefValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<AppProvider>(
        builder: (context, AppProvider appProvider, child) {
          return SafeArea(
            child: Consumer<AppProvider>(
              builder: (context, provider, _) {
                return Scaffold(
                  appBar: buildAppBar(appProvider),
                  body: Stack(
                    children: [
                      ListView(
                        primary: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 42, right: 32, left: 32),
                        children: [
                          personDetailsList[provider.selectedPersonalIndex]
                        ],
                      ),
                      isLoading ? const AppLoader() : const SizedBox(),
                    ],
                  ),
                  floatingActionButton: (widget.isEdit &&
                    (appProvider.selectedPersonalIndex == 1 || appProvider.selectedPersonalIndex == 2 || appProvider.selectedPersonalIndex == 7 || appProvider.selectedPersonalIndex >= 9))
                      ? FloatingActionButton(
                          onPressed: () => Navigator.pop(
                            context,
                            appProvider.selectedPersonalIndex == 9
                                ? appProvider.jobNameController.text
                                : appProvider.aboutMeController.text,
                          ),
                          backgroundColor: ColorConstant.pink,
                          child: const Icon(
                            Icons.done,
                            color: ColorConstant.white,
                          ),
                        )
                      : const SizedBox(),
                  bottomNavigationBar: (isLoading || widget.isEdit)
                      ? const SizedBox()
                      : buildBottomNavBarView(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Consumer<AppProvider> buildBottomNavBarView() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20).copyWith(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSkipView(appProvider, context),
              fabView(appProvider),
            ],
          ),
        );
      },
    );
  }

  GestureDetector buildSkipView(AppProvider appProvider, BuildContext context) {
    return GestureDetector(
      onTap: () {
        appProvider.selectedPersonalIndex < personDetailsList.length - 1
            ? appProvider
                .changePersonalScreen(appProvider.selectedPersonalIndex + 1)
            : goToHome(appProvider);
      },
      child: Container(
        color: ColorConstant.transparent,
        padding: const EdgeInsets.only(left: 30),
        child: AppText(
          text: 'Skip'.toUpperCase(),
          fontSize: 18,
          fontColor: ColorConstant.black,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  PreferredSize buildAppBar(AppProvider appProvider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        widget.isEdit
            ? AppBar().preferredSize.height
            : (appProvider.selectedPersonalIndex == 0 || isLoading)
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
              padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 16),
              child: StepProgressIndicator(
                totalSteps: personDetailsList.length - 1,
                currentStep: appProvider.selectedPersonalIndex,
                size: 10,
                padding: 0,
                selectedColor: ColorConstant.lightYellow,
                unselectedColor: ColorConstant.indicatorColor,
                roundedEdges: const Radius.circular(10),
              ),
            ),
    );
  }

  Padding fabView(AppProvider appProvider) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FloatingActionButton(
        backgroundColor: ColorConstant.yellow,
        elevation: 0,
        onPressed: () => moveToNext(appProvider),
        child: const AppImageAsset(
          image: ImageConstant.forwardArrowIcon,
          color: ColorConstant.white,
          height: 20,
          width: 20,
        ),
      ),
    );
  }

  Future<void> setPrefValue() async {
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    if (widget.userModel != null && widget.userModel!.isNotEmpty) {
      appProvider.userModel = userModelFromJson(widget.userModel!);
      logs('message --> ${widget.userModel}');
      logs('app message --> ${appProvider.userModel}');
    }
    await setPrefBoolValue(isProfileCompleted, true);
  }

  void moveToNext(AppProvider appProvider) {
    (appProvider.selectedPersonalIndex == 1 && appProvider.countryController.text.isEmpty)
        ? showMessage(context, message: 'Please select your country', isError: true)
        : (appProvider.selectedPersonalIndex == 2 && appProvider.cityController.text.isEmpty)
          ? showMessage(context, message: 'Please select your city', isError: true)
          : (appProvider.selectedPersonalIndex == 3 && appProvider.selectedHeight == -1)
              ? showMessage(context, message: 'Please select your height', isError: true)
              : (appProvider.selectedPersonalIndex == 4 && appProvider.selectedMaritalStatus == -1)
                  ? showMessage(context, message: 'Please select your marital status', isError: true)
                  : (appProvider.selectedPersonalIndex == 5 && appProvider.selectedSmokingType == -1)
                      ? showMessage(context, message: 'Please select your smoking type', isError: true)
                      : (appProvider.selectedPersonalIndex == 6 && appProvider.selectedDrinking == -1)
                          ? showMessage(context, message: 'Please select your drinking type', isError: true)
                          : (appProvider.selectedPersonalIndex == 8 && appProvider.selectedDrinking == -1)
                              ? showMessage(context, message: 'Please select your education', isError: true)
                              : (appProvider.selectedPersonalIndex == 7 && appProvider.selectedLanguage.isEmpty)
                                  ? showMessage(context, message: 'Please select at least one language you know', isError: true)
                                  : (appProvider.selectedPersonalIndex == 9 &&
                                          (appProvider.jobNameController.text.isEmpty || appProvider.jobNameController.text.trim().isEmpty))
                                      ? showMessage(context, message: 'Please enter your job title', isError: true)
                                      : (appProvider.selectedPersonalIndex == 10 &&
                                              (appProvider.aboutMeController.text.isEmpty || appProvider.aboutMeController.text.trim().isEmpty))
                                          ? showMessage(context, message: 'Please enter about your self', isError: true)
                                          : appProvider.selectedPersonalIndex < personDetailsList.length - 1
                                              ? appProvider.changePersonalScreen(appProvider.selectedPersonalIndex + 1)
                                              : goToHome(appProvider);
  }

  Future<void> goToHome(AppProvider appProvider) async {
    setState(() {
      isLoading = true;
    });
    String? fcmToken = await NotificationService.generateFCMToken(context);
    appProvider.userModel.fcmToken = fcmToken;
    logs('appProvider --> ${appProvider.userModel.toJson()}');
    if (appProvider.userModel.userId != null && appProvider.userModel.userId!.isNotEmpty) {
      await userService.createUser(context, appProvider.userModel);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      showMessage(context, message: 'Something went wrong please try again.!');
      await AuthService().userSignOut(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LogInScreen()),
        (route) => false,
      );
    }
  }
}
