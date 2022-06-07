import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsageTypeScreen extends StatefulWidget {
  const UsageTypeScreen({Key? key}) : super(key: key);

  @override
  State<UsageTypeScreen> createState() => UsageTypeScreenState();
}

class UsageTypeScreenState extends State<UsageTypeScreen> {
  List<String> usageTypeLists = [
    'A Relationship or date',
    'To get marry',
    'I\'m not sure',
    'Something Casual'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, AppProvider appProvider, child) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: AppText(
                text: 'Why you use rowdy baby?',
                fontColor: ColorConstant.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 46),
            ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              itemCount: usageTypeLists.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: appProvider.selectedUsageType == index ? 4 : 0,
                  shadowColor: ColorConstant.dropShadow,
                  color: appProvider.selectedUsageType == index
                      ? ColorConstant.white
                      : ColorConstant.darkPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 58,
                    child: ListTile(
                      onTap: () {
                        appProvider.changeUsageType(index);
                        appProvider.userModel.usageType = usageTypeLists[index];
                      },
                      minLeadingWidth: 0,
                      title: AppText(
                        text: usageTypeLists[index],
                        fontSize: 20,
                        fontColor: appProvider.selectedUsageType == index
                            ? ColorConstant.yellow
                            : ColorConstant.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                      trailing: appProvider.selectedUsageType == index
                          ? const AppImageAsset(
                              image: ImageConstant.yellowTickIcon)
                          : const SizedBox(),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
            ),
          ],
        );
      },
    );
  }
}
