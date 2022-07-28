// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/filter_module/advance_filter_screen.dart';
import 'package:dating/screen/filter_module/filter_caste_screen.dart';
import 'package:dating/screen/filter_module/filter_city_screen.dart';
import 'package:dating/screen/filter_module/filter_country_screen.dart';
import 'package:dating/screen/filter_module/filter_religion_screen.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  EdgeInsetsGeometry bodyPadding = const EdgeInsets.symmetric(horizontal: 30);
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return SafeArea(
      child: Consumer<FilterProvider>(
        builder: (BuildContext context, FilterProvider filterProvider, _) {
          return Consumer<UserProfileProvider>(
            builder: (context, UserProfileProvider userProfileProvider, _) {
              return Scaffold(
                appBar: buildAppBar(filterProvider),
                body: filterProvider.isCountryScreen
                    ? const FilterCountryScreen()
                    : filterProvider.isCityScreen
                        ? const FilterCityScreen()
                        : filterProvider.isCastScreen
                            ? const FilterCastScreen()
                            : filterProvider.isReligionScreen
                                ? const FilterReligionScreen()
                                : Column(
                                    children: [
                                      Expanded(
                                        child: ListView(
                                          primary: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(top: 36),
                                          children: [
                                            Padding(
                                              padding: bodyPadding,
                                              child: const AppText(
                                                text: 'I\'m interested in',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                fontColor: ColorConstant.black,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            buildGenderSelectView(
                                                filterProvider),
                                            const SizedBox(height: 16),
                                            const Divider(
                                              color: ColorConstant.hintColor,
                                              thickness: 1.2,
                                            ),
                                            const SizedBox(height: 16),
                                            GestureDetector(
                                              onTap: () {
                                                filterProvider.isCastScreen =
                                                    true;
                                                filterProvider
                                                    .isReligionScreen = false;
                                                filterProvider.isCountryScreen =
                                                    false;
                                                filterProvider.isCityScreen =
                                                    false;
                                                filterProvider
                                                    .notifyListeners();
                                              },
                                              child: buildCastReligionView(
                                                'Caste',
                                                filterProvider,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(
                                              color: ColorConstant.hintColor,
                                              thickness: 1.2,
                                            ),
                                            const SizedBox(height: 16),
                                            Padding(
                                              padding: bodyPadding,
                                              child: TextFormField(
                                                controller: filterProvider
                                                    .subCastController,
                                                style: const TextStyle(
                                                  fontFamily:
                                                      AppTheme.defaultFont,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: ColorConstant.pink,
                                                  letterSpacing: 0.48,
                                                ),
                                                cursorColor: ColorConstant.pink,
                                                textInputAction:
                                                    TextInputAction.done,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Sub Caste',
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        AppTheme.defaultFont,
                                                    fontSize: 14,
                                                    color: Color(0XFFBDBDBD),
                                                    letterSpacing: 0.48,
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(),
                                                  focusedBorder:
                                                      UnderlineInputBorder(),
                                                  filled: false,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(
                                              color: ColorConstant.hintColor,
                                              thickness: 1.2,
                                            ),
                                            const SizedBox(height: 16),
                                            GestureDetector(
                                              onTap: () {
                                                filterProvider.isCastScreen =
                                                    false;
                                                filterProvider
                                                    .isReligionScreen = true;
                                                filterProvider.isCountryScreen =
                                                    false;
                                                filterProvider.isCityScreen =
                                                    false;
                                                filterProvider
                                                    .notifyListeners();
                                              },
                                              child: buildCastReligionView(
                                                'Religion',
                                                filterProvider,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(
                                              color: ColorConstant.hintColor,
                                              thickness: 1.2,
                                            ),
                                            const SizedBox(height: 16),
                                            buildAgeView(filterProvider),
                                            const SizedBox(height: 16),
                                            const Divider(
                                              color: ColorConstant.hintColor,
                                              thickness: 1.2,
                                            ),
                                            const SizedBox(height: 16),
                                            buildHeightView(filterProvider),
                                            const SizedBox(height: 16),
                                            // buildAdvanceFilterCard(
                                            //     filterProvider),
                                          ],
                                        ),
                                      ),
                                      buildAdvanceFilterCard(
                                          filterProvider, userProfileProvider),
                                    ],
                                  ),
                floatingActionButton: (filterProvider.isCountryScreen ||
                        filterProvider.isCityScreen)
                    ? FloatingActionButton(
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: ColorConstant.white,
                        child: const Icon(
                          Icons.done,
                          color: ColorConstant.pink,
                        ),
                      )
                    : (!filterProvider.isCountryScreen &&
                            !filterProvider.isCityScreen &&
                            !filterProvider.isCastScreen &&
                            !filterProvider.isReligionScreen)
                        ? FloatingActionButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              UserService().addFilters(
                                context,
                                currentUserId:
                                    userProfileProvider.currentUserId,
                                filterMap: {},
                              );
                              filterProvider.filterMap.clear();
                              filterProvider.selectedGender =
                                  userProfileProvider.interestGender;
                              filterProvider.startAge = 18;
                              filterProvider.endAge = 34;
                              filterProvider.startHeight = 4.0;
                              filterProvider.endHeight = 5.0;
                              filterProvider.selectedCountry.clear();
                              filterProvider.selectedCity.clear();
                              filterProvider.selectedCast.clear();
                              filterProvider.selectedReligion.clear();
                              filterProvider.selectedMaritalStatus.clear();
                              filterProvider.selectedSmokeStatus.clear();
                              filterProvider.selectedDrinkStatus.clear();
                              filterProvider.selectedEducationStatus.clear();
                              filterProvider.subCastController.clear();
                              filterProvider.selectedLanguageStatus.clear();
                              filterProvider.selectedUsageTypeStatus.clear();
                              filterProvider.notifyListeners();
                              final provider = Provider.of<HomeProvider>(
                                  context,
                                  listen: false);
                              provider.showFilterCard = false;
                              provider.getAllUsers(context);
                              provider.isCardCompleted = false;
                              provider.notifyListeners();
                            },
                            backgroundColor: ColorConstant.orange,
                            child: const Icon(
                              Icons.refresh,
                              color: ColorConstant.white,
                            ),
                          )
                        : const SizedBox(),
                bottomNavigationBar: (!filterProvider.isCountryScreen &&
                        !filterProvider.isCityScreen &&
                        !filterProvider.isCastScreen &&
                        !filterProvider.isReligionScreen)
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppElevatedButton(
                          text: 'Done',
                          height: 50,
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          borderRadius: 10,
                          onPressed: () =>
                              filterTap(filterProvider, userProfileProvider),
                        ),
                      )
                    : const SizedBox(),
              );
            },
          );
        },
      ),
    );
  }

  StatelessWidget buildAdvanceFilterCard(FilterProvider filterProvider, UserProfileProvider userProfileProvider) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        addKeys(filterProvider);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdvanceFilterScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 26),
        decoration: const BoxDecoration(
          color: ColorConstant.transparent,
        ),
        child: const AppText(
          text: 'Advance Filter',
          fontColor: ColorConstant.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ),
    );
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
      elevation: 0,
      color: ColorConstant.hintColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 50,
        child: ListTile(
          onTap: () {
            addKeys(filterProvider);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdvanceFilterScreen(),
              ),
            );
          },
          minLeadingWidth: 0,
          title: const AppText(
            text: 'Advance filters',
            fontSize: 16,
            fontColor: ColorConstant.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
          trailing: const AppImageAsset(
            image: ImageConstant.forwardIcon,
            height: 18,
          ),
        ),
      ),
    );
  }

  Padding buildHeightView(FilterProvider filterProvider) {
    return Padding(
      padding: bodyPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: 'Height',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontColor: ColorConstant.black,
              ),
              const Spacer(),
              AppText(
                text:
                    '${filterProvider.startHeight.toStringAsFixed(1)} - ${filterProvider.endHeight.toStringAsFixed(1)}',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontColor: ColorConstant.pink,
              ),
            ],
          ),
          RangeSlider(
            min: 4,
            max: 8,
            values: RangeValues(
              filterProvider.startHeight,
              filterProvider.endHeight,
            ),
            activeColor: ColorConstant.pink,
            inactiveColor: ColorConstant.hintColor,
            onChanged: (values) => filterProvider.selectHeightRange(values),
          )
        ],
      ),
    );
  }

  Padding buildAgeView(FilterProvider filterProvider) {
    return Padding(
      padding: bodyPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: 'Age',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontColor: ColorConstant.black,
              ),
              const Spacer(),
              AppText(
                text:
                    '${filterProvider.startAge.round()} - ${filterProvider.endAge.round()}',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontColor: ColorConstant.pink,
              ),
            ],
          ),
          RangeSlider(
            min: 18,
            max: 100,
            values: RangeValues(
              filterProvider.startAge,
              filterProvider.endAge,
            ),
            activeColor: ColorConstant.pink,
            inactiveColor: ColorConstant.hintColor,
            onChanged: (values) => filterProvider.selectAgeRange(values),
          )
        ],
      ),
    );
  }

  Padding buildGenderSelectView(FilterProvider filterProvider) {
    return Padding(
      padding: bodyPadding,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorConstant.hintColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: List.generate(
            genderList.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () => filterProvider.changeGender(index),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: filterProvider.selectedGender == index
                        ? ColorConstant.pink
                        : ColorConstant.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(
                    text: genderList[index],
                    fontColor: filterProvider.selectedGender == index
                        ? ColorConstant.white
                        : ColorConstant.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildCastReligionView(String title, FilterProvider filterProvider) {
    return Container(
      decoration: const BoxDecoration(color: ColorConstant.transparent),
      padding: bodyPadding,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: title,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontColor: ColorConstant.black,
              ),
              if ((title == 'Caste' &&
                      filterProvider.selectedCast.isNotEmpty) ||
                  (title == 'Religion' &&
                      filterProvider.selectedReligion.isNotEmpty))
                AppText(
                  text: title == 'Caste'
                      ? filterProvider.selectedCast.join(', ')
                      : filterProvider.selectedReligion.join(', '),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontColor: ColorConstant.pink,
                ),
            ],
          ),
          const Spacer(),
          const AppImageAsset(
            image: ImageConstant.forwardIcon,
            height: 18,
          ),
        ],
      ),
    );
  }

  PreferredSize buildAppBar(FilterProvider filterProvider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
          (filterProvider.isCountryScreen || filterProvider.isCityScreen)
              ? 20
              : AppBar().preferredSize.height * 1.5),
      child: Container(
        padding: const EdgeInsets.only(left: 14, top: 18, bottom: 14),
        decoration: BoxDecoration(
          color: (filterProvider.isCountryScreen ||
                  filterProvider.isCityScreen ||
                  filterProvider.isCastScreen ||
                  filterProvider.isReligionScreen)
              ? ColorConstant.pink
              : ColorConstant.themeScaffold,
          border: Border(
            bottom: BorderSide(
              color: (filterProvider.isCountryScreen ||
                      filterProvider.isCityScreen ||
                      filterProvider.isCastScreen ||
                      filterProvider.isReligionScreen)
                  ? ColorConstant.pink
                  : ColorConstant.hintColor,
              width: 1.8,
            ),
          ),
        ),
        child: (filterProvider.isCountryScreen || filterProvider.isCityScreen)
            ? Container()
            : (filterProvider.isCastScreen || filterProvider.isReligionScreen)
                ? GestureDetector(
                    onTap: () {
                      filterProvider.isCastScreen = false;
                      filterProvider.isReligionScreen = false;
                      filterProvider.isCountryScreen = false;
                      filterProvider.isCityScreen = false;
                      filterProvider.notifyListeners();
                      if (filterProvider.isCountryScreen ||
                          filterProvider.isCityScreen) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorConstant.transparent,
                      ),
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: const AppImageAsset(
                        image: ImageConstant.closeIcon,
                        color: ColorConstant.themeScaffold,
                        height: 40,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const AppImageAsset(
                            image: ImageConstant.circleBackIcon),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            AppText(
                              text: 'Filter',
                              fontColor: ColorConstant.pink,
                              fontSize: 20,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.bold,
                            ),
                            AppText(
                              text:
                                  'People visible based on this filters selection',
                              fontColor: Color(0XFF7B7B7B),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    );
  }

  Future<void> filterTap(FilterProvider filterProvider,
      UserProfileProvider userProfileProvider) async {
    addKeys(filterProvider);
    await userService.addFilters(
      context,
      currentUserId: userProfileProvider.currentUserId,
      filterMap: filterProvider.filterMap,
    );
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.showFilterCard = true;
    homeProvider.getAllUsers(context);
    homeProvider.isCardCompleted = false;
    homeProvider.notifyListeners();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const HomeScreen(selectedIndex: 1)),
      (route) => false,
    );
  }

  void addKeys(FilterProvider filterProvider) {
    if (filterProvider.selectedGender != -1) {
      filterProvider.filterMap['gender'] = filterProvider.selectedGender == 0
          ? 'Male'
          : filterProvider.selectedGender == 1
              ? 'Female'
              : 'Others';
    }
    if (filterProvider.selectedCast.isNotEmpty) {
      filterProvider.filterMap['cast'] = filterProvider.selectedCast;
    }
    if (filterProvider.selectedReligion.isNotEmpty) {
      filterProvider.filterMap['religion'] = filterProvider.selectedReligion;
    }
    if (filterProvider.subCastController.text.isNotEmpty) {
      filterProvider.filterMap['subCaste'] =
          filterProvider.subCastController.text;
    }
    filterProvider.filterMap['age'] =
        '${filterProvider.startAge.round()}-${filterProvider.endAge.round()}';
    filterProvider.filterMap['height'] =
        '${filterProvider.startHeight.floor()}-${filterProvider.endHeight.ceil()}';
    // filterProvider.selectedMaritalStatus.clear();
    // filterProvider.selectedSmokeStatus.clear();
    // filterProvider.selectedDrinkStatus.clear();
    // filterProvider.selectedEducationStatus.clear();
    // filterProvider.selectedLanguageStatus.clear();
    // filterProvider.selectedUsageTypeStatus.clear();
    filterProvider.notifyListeners();
  }
}

class ClearAllButton extends StatelessWidget {
  const ClearAllButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProfileProvider, FilterProvider>(
      builder: (context, userProfileProvider, filterProvider, _) {
        return GestureDetector(
          onTap: () {
            UserService().addFilters(
              context,
              currentUserId: userProfileProvider.currentUserId,
              filterMap: {},
            );
            filterProvider.filterMap.clear();
            filterProvider.selectedGender = userProfileProvider.interestGender;
            filterProvider.startAge = 18;
            filterProvider.endAge = 34;
            filterProvider.startHeight = 4.0;
            filterProvider.endHeight = 5.0;
            filterProvider.selectedCountry.clear();
            filterProvider.selectedCity.clear();
            filterProvider.selectedCast.clear();
            filterProvider.selectedReligion.clear();
            filterProvider.selectedMaritalStatus.clear();
            filterProvider.selectedSmokeStatus.clear();
            filterProvider.selectedDrinkStatus.clear();
            filterProvider.selectedEducationStatus.clear();
            filterProvider.subCastController.clear();
            filterProvider.selectedLanguageStatus.clear();
            filterProvider.selectedUsageTypeStatus.clear();
            filterProvider.notifyListeners();
            final provider = Provider.of<HomeProvider>(context, listen: false);
            provider.showFilterCard = false;
            provider.getAllUsers(context);
            provider.isCardCompleted = false;
            provider.notifyListeners();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 26),
            decoration: const BoxDecoration(
              color: ColorConstant.transparent,
            ),
            child: const AppText(
              text: 'Clear all',
              fontColor: ColorConstant.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
