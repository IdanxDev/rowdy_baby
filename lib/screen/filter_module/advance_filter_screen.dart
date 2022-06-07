import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/advance_filter_list_model.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/widgets/app_bottom_sheet.dart';
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
  EdgeInsetsGeometry bodyPadding =
      const EdgeInsets.symmetric(horizontal: 30, vertical: 25);
  List<AdvanceFilterListModel> advanceFilterListModel = [
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
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return SafeArea(
      child: Consumer<FilterProvider>(
        builder: (BuildContext context, FilterProvider filterProvider, _) {
          return Scaffold(
            appBar: buildAppBar(filterProvider),
            body: ListView.separated(
              primary: true,
              physics: const BouncingScrollPhysics(),
              itemCount: advanceFilterListModel.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, _, __) => AppBottomSheet(
                      currentIndex: index,
                      filterSheetData: advanceFilterListModel[index],
                    ),
                  ),
                ),
                child: buildFilterCard(advanceFilterListModel[index]),
              ),
              separatorBuilder: (context, index) => const Divider(
                  color: ColorConstant.hintColor, thickness: 1.2, height: 0),
            ),
          );
        },
      ),
    );
  }

  Container buildFilterCard(AdvanceFilterListModel advanceFilterListModel) {
    String filterData = '';
    for (var element in advanceFilterListModel.sheetOptions!) {
      if (element.isSelected) {
        filterData = '${element.name}, $filterData';
        filterData = filterData.trim().substring(0, filterData.length - 1);
      }
    }
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
                  text: advanceFilterListModel.sheetTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontColor: ColorConstant.black,
                ),
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
}
