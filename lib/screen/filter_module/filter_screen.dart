// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/screen/filter_module/advance_filter_screen.dart';
import 'package:dating/screen/filter_module/filter_caste_screen.dart';
import 'package:dating/screen/filter_module/filter_religion_screen.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  EdgeInsetsGeometry bodyPadding = const EdgeInsets.symmetric(horizontal: 30);
  List<String> gender = ['Male', 'Female', 'Others'];

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return SafeArea(
      child: Consumer<FilterProvider>(
        builder: (BuildContext context, FilterProvider filterProvider, _) {
          return Scaffold(
            appBar: buildAppBar(filterProvider),
            body: filterProvider.isCastScreen
                ? const FilterCastScreen()
                : filterProvider.isReligionScreen
                    ? const FilterReligionScreen()
                    : ListView(
                        primary: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 36),
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
                          buildGenderSelectView(filterProvider),
                          const SizedBox(height: 16),
                          const Divider(
                              color: ColorConstant.hintColor, thickness: 1.2),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              filterProvider.isCastScreen = true;
                              filterProvider.isReligionScreen = false;
                              filterProvider.notifyListeners();
                            },
                            child:
                                buildCastReligionView('Cast', filterProvider),
                          ),
                          const SizedBox(height: 16),
                          const Divider(
                              color: ColorConstant.hintColor, thickness: 1.2),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              filterProvider.isCastScreen = false;
                              filterProvider.isReligionScreen = true;
                              filterProvider.notifyListeners();
                            },
                            child: buildCastReligionView(
                                'Religion', filterProvider),
                          ),
                          const SizedBox(height: 16),
                          const Divider(
                              color: ColorConstant.hintColor, thickness: 1.2),
                          const SizedBox(height: 16),
                          buildAgeView(filterProvider),
                          const SizedBox(height: 16),
                          const Divider(
                              color: ColorConstant.hintColor, thickness: 1.2),
                          const SizedBox(height: 16),
                          buildHeightView(filterProvider),
                          const SizedBox(height: 16),
                          buildAdvanceFilterCard(),
                        ],
                      ),
            bottomNavigationBar: (!filterProvider.isCastScreen &&
                    !filterProvider.isReligionScreen)
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppElevatedButton(
                      text: 'Save',
                      height: 50,
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      borderRadius: 10,
                      onPressed: () {},
                    ),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }

  Card buildAdvanceFilterCard() {
    return Card(
      margin: bodyPadding,
      elevation: 0,
      color: ColorConstant.hintColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 58,
        child: ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AdvanceFilterScreen()),
          ),
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
            gender.length,
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
                    text: gender[index],
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
              if ((title == 'Cast' && filterProvider.selectedCast.isNotEmpty) ||
                  (title == 'Religion' &&
                      filterProvider.selectedReligion.isNotEmpty))
                AppText(
                  text: title == 'Cast'
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
      preferredSize: Size.fromHeight(AppBar().preferredSize.height * 1.5),
      child: Container(
        padding: const EdgeInsets.only(left: 14, top: 18, bottom: 14),
        decoration: BoxDecoration(
          color:
              (filterProvider.isCastScreen || filterProvider.isReligionScreen)
                  ? ColorConstant.pink
                  : ColorConstant.themeScaffold,
          border: Border(
            bottom: BorderSide(
              color: (filterProvider.isCastScreen ||
                      filterProvider.isReligionScreen)
                  ? ColorConstant.pink
                  : ColorConstant.hintColor,
              width: 1.8,
            ),
          ),
        ),
        child: (filterProvider.isCastScreen || filterProvider.isReligionScreen)
            ? GestureDetector(
                onTap: () {
                  filterProvider.isCastScreen = false;
                  filterProvider.isReligionScreen = false;
                  filterProvider.notifyListeners();
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
}
