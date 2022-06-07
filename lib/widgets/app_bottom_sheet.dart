// ignore_for_file: must_be_immutable

import 'package:dating/constant/color_constant.dart';
import 'package:dating/model/advance_filter_list_model.dart';
import 'package:dating/model/multi_selection_model.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBottomSheet extends StatefulWidget {
  final int currentIndex;
  final AdvanceFilterListModel? filterSheetData;

  const AppBottomSheet({
    Key? key,
    this.currentIndex = 0,
    @required this.filterSheetData,
  }) : super(key: key);

  @override
  State<AppBottomSheet> createState() => AppBottomSheetState();
}

class AppBottomSheetState extends State<AppBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<FilterProvider>(
        builder: (BuildContext context, FilterProvider filterProvider, _) {
          return Scaffold(
            backgroundColor: ColorConstant.transparent.withOpacity(0.5),
            body: Column(
              children: [
                buildSheetBarrierView(context),
                buildSheetView(context, filterProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Expanded buildSheetView(BuildContext context, FilterProvider filterProvider) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.only(
          top: 40,
          left: 35,
          right: 25,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: ColorConstant.grey),
          color: ColorConstant.white,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            buildSheetAppBar(context),
            const SizedBox(height: 34),
            buildSheetBody(filterProvider),
          ],
        ),
      ),
    );
  }

  ListView buildSheetBody(FilterProvider filterProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.filterSheetData!.sheetOptions!.length,
      itemBuilder: (context, index) {
        MultiSelectionModel sheetData =
            widget.filterSheetData!.sheetOptions![index];
        return Container(
          height: 58,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0XFFF2F2F2)),
            ),
          ),
          child: ListTile(
            onTap: () => sortData(filterProvider, sheetData),
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            title: AppText(
              text: sheetData.name,
              fontSize: 16,
              fontColor: sheetData.isSelected
                  ? ColorConstant.darkPink
                  : ColorConstant.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
            subtitle: const AppText(text: ''),
            leading: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: ColorConstant.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: sheetData.isSelected
                      ? ColorConstant.darkPink
                      : ColorConstant.dropShadow,
                  width: 1.7,
                ),
              ),
              child: sheetData.isSelected
                  ? const Icon(
                      Icons.done,
                      size: 16,
                      color: ColorConstant.darkPink,
                    )
                  : const SizedBox(),
            ),
          ),
        );
      },
    );
  }

  GestureDetector buildSheetAppBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: const BoxDecoration(color: ColorConstant.transparent),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AppText(
                text: widget.filterSheetData!.sheetTitle,
                fontColor: ColorConstant.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                maxLines: 2,
              ),
            ),
            const Spacer(),
            AppText(
              text: 'done'.toUpperCase(),
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildSheetBarrierView(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: ColorConstant.transparent,
          width: double.infinity,
        ),
      ),
    );
  }

  void sortData(FilterProvider filterProvider, MultiSelectionModel sheetData) {
    if (widget.currentIndex == 0) {
      filterProvider.addMaritalStatus(sheetData);
    } else if (widget.currentIndex == 1) {
      filterProvider.addSmokingStatus(sheetData);
    } else if (widget.currentIndex == 2) {
      filterProvider.addDrinkingStatus(sheetData);
    } else if (widget.currentIndex == 3) {
      filterProvider.addEducationStatus(sheetData);
    } else if (widget.currentIndex == 4) {
      filterProvider.addLanguage(sheetData);
    } else if (widget.currentIndex == 5) {
      filterProvider.addUsageStatus(sheetData);
    }
  }
}
