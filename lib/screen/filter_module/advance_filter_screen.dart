// ignore_for_file: use_build_context_synchronously, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/advance_filter_list_model.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/filter_module/filter_screen.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/premium_screen/premium_bottom_sheet.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_bottom_sheet.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvanceFilterScreen extends StatefulWidget {
  const AdvanceFilterScreen({Key? key}) : super(key: key);

  @override
  State<AdvanceFilterScreen> createState() => AdvanceFilterScreenState();
}

class AdvanceFilterScreenState extends State<AdvanceFilterScreen> {
  UserService userService = UserService();
  EdgeInsetsGeometry bodyPadding = const EdgeInsets.symmetric(horizontal: 30, vertical: 25);
  List<AdvanceFilterListModel> advanceFilterListModel = [
    AdvanceFilterListModel(sheetTitle: 'Country'),
    AdvanceFilterListModel(sheetTitle: 'City'),
    AdvanceFilterListModel(
      sheetTitle: 'Marital Status',
      sheetOptions: FilterProvider().maritalStatusList,
    ),
    AdvanceFilterListModel(
      sheetTitle: 'Smoke',
      sheetOptions: FilterProvider().smokeStatusList,
    ),
    AdvanceFilterListModel(
      sheetTitle: 'Drink',
      sheetOptions: FilterProvider().drinkStatusList,
    ),
    AdvanceFilterListModel(
      sheetTitle: 'Education',
      sheetOptions: FilterProvider().educationStatusList,
    ),
    AdvanceFilterListModel(
      sheetTitle: 'Languages speak?',
      sheetOptions: FilterProvider().languageList,
    ),
    AdvanceFilterListModel(
      sheetTitle: 'Why you use rowdy baby?',
      sheetOptions: FilterProvider().usageTypeList,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return SafeArea(
      child: Consumer<FilterProvider>(
        builder: (BuildContext context, FilterProvider filterProvider, _) {
          return Consumer<UserProfileProvider>(
            builder: (context, userProfileProvider, _) {
              return Scaffold(
                appBar: buildAppBar(filterProvider),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        primary: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: advanceFilterListModel.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            if (userProfileProvider
                                .currentUserData!.isPremiumUser) {
                              if (index >= 2) {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context, _, __) =>
                                        AppBottomSheet(
                                      currentIndex: index,
                                      filterSheetData:
                                          advanceFilterListModel[index],
                                    ),
                                  ),
                                );
                              } else if (index == 0) {
                                filterProvider.isCountryScreen = true;
                                filterProvider.isCityScreen = false;
                                filterProvider.isReligionScreen = false;
                                filterProvider.isCastScreen = false;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const FilterScreen()),
                                );
                              } else if (index == 1) {
                                if(filterProvider.selectedCountry.isNotEmpty) {
                                  filterProvider.isCityScreen = true;
                                  filterProvider.isCountryScreen = false;
                                  filterProvider.isReligionScreen = false;
                                  filterProvider.isCastScreen = false;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const FilterScreen()),
                                  );
                                } else {
                                  showMessage(context, message: 'Please select country first.!', isError: true);
                                }
                              }
                            } else {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context, _, __) =>
                                      const PremiumBottomSheet(),
                                ),
                              );
                            }
                          },
                          child: buildFilterCard(index, filterProvider),
                        ),
                        separatorBuilder: (context, index) => const Divider(
                            color: ColorConstant.hintColor,
                            thickness: 1.2,
                            height: 0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        UserService().addFilters(
                          context,
                          currentUserId: userProfileProvider.currentUserId,
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
                        filterProvider.selectedLanguageStatus.clear();
                        filterProvider.selectedUsageTypeStatus.clear();
                        filterProvider.subCastController.clear();
                        filterProvider.notifyListeners();
                        final provider =
                            Provider.of<HomeProvider>(context, listen: false);
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
                    ),
                  ],
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppElevatedButton(
                    text: 'Done',
                    height: 50,
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    borderRadius: 10,
                    onPressed: () =>
                        filterTap(filterProvider, userProfileProvider),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Container buildFilterCard(int index, FilterProvider filterProvider) {
    String filterData = index == 0
        ? filterProvider.selectedCountry.join(', ')
        : index == 1
            ? filterProvider.selectedCity.join(', ')
            : index == 2
                ? filterProvider.selectedMaritalStatus.join(', ')
                : index == 3
                    ? filterProvider.selectedSmokeStatus.join(', ')
                    : index == 4
                        ? filterProvider.selectedDrinkStatus.join(', ')
                        : index == 5
                            ? filterProvider.selectedEducationStatus.join(', ')
                            : index == 6
                                ? filterProvider.selectedLanguageStatus
                                    .join(', ')
                                : index == 7
                                    ? filterProvider.selectedUsageTypeStatus
                                        .join(', ')
                                    : '';
    return Container(
      padding: bodyPadding,
      decoration: const BoxDecoration(
        color: ColorConstant.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: advanceFilterListModel[index].sheetTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontColor: ColorConstant.black,
                ),
                if (filterData.isNotEmpty) const SizedBox(height: 4),
                if (filterData.isNotEmpty)
                  AppText(
                    text: filterData.trim(),
                    fontColor: const Color(0XFF7B7B7B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
          ),
          const Spacer(),
          const AppImageAsset(image: ImageConstant.plusIcon),
        ],
      ),
    );
  }

  PreferredSize buildAppBar(FilterProvider filterProvider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height * 1.5),
      child: Container(
        padding: const EdgeInsets.only(left: 14, top: 18, bottom: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorConstant.hintColor,
              width: 1.8,
            ),
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const AppImageAsset(image: ImageConstant.circleBackIcon),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AppText(
                    text: 'Advance filters',
                    fontColor: ColorConstant.pink,
                    fontSize: 20,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText(
                    text: 'People visible based on this filters selection',
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
    if (filterProvider.selectedCountry.isNotEmpty) {
      filterProvider.filterMap['country'] = filterProvider.selectedCountry;
    }
    if (filterProvider.selectedCity.isNotEmpty) {
      filterProvider.filterMap['city'] = filterProvider.selectedCity;
    }
    if (filterProvider.selectedMaritalStatus.isNotEmpty) {
      filterProvider.filterMap['maritalStatus'] =
          filterProvider.selectedMaritalStatus;
    }
    if (filterProvider.selectedSmokeStatus.isNotEmpty) {
      filterProvider.filterMap['smoke'] = filterProvider.selectedSmokeStatus;
    }
    if (filterProvider.selectedDrinkStatus.isNotEmpty) {
      filterProvider.filterMap['drink'] = filterProvider.selectedDrinkStatus;
    }
    if (filterProvider.selectedEducationStatus.isNotEmpty) {
      filterProvider.filterMap['education'] =
          filterProvider.selectedEducationStatus;
    }
    if (filterProvider.selectedLanguageStatus.isNotEmpty) {
      filterProvider.filterMap['language'] =
          filterProvider.selectedLanguageStatus;
    }
    if (filterProvider.selectedUsageTypeStatus.isNotEmpty) {
      filterProvider.filterMap['usageType'] =
          filterProvider.selectedUsageTypeStatus;
    }
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
    filterProvider.isCastScreen = false;
    filterProvider.isReligionScreen = false;
    filterProvider.isCountryScreen = false;
    filterProvider.isCityScreen = false;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const HomeScreen(selectedIndex: 1)),
      (route) => false,
    );
  }
}
