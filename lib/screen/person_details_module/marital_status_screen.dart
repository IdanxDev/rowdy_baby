import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaritalStatusScreen extends StatefulWidget {
  const MaritalStatusScreen({Key? key}) : super(key: key);

  @override
  State<MaritalStatusScreen> createState() => MaritalStatusScreenState();
}

class MaritalStatusScreenState extends State<MaritalStatusScreen> {
  List<String> maritalStatusList = <String>[
    'Single',
    'Single with Kids',
    'Divorced',
    'Divorced with Kids',
    'Widowed',
    'Widowed with Kids',
    'Separated',
    'Separated with Kids',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, AppProvider appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Marital status',
              fontColor: ColorConstant.pink,
              fontSize: 40,
              maxLines: 2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 34),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: maritalStatusList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 58,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0XFFF2F2F2)),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      appProvider.changeMaritalStatus(index);
                      appProvider.userModel.maritalStatus =
                          maritalStatusList[index];
                    },
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    title: AppText(
                      text: maritalStatusList[index],
                      fontSize: 20,
                      fontColor: appProvider.selectedMaritalStatus == index
                          ? ColorConstant.darkPink
                          : ColorConstant.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                    trailing: appProvider.selectedMaritalStatus == index
                        ? const AppImageAsset(image: ImageConstant.pinkTickIcon)
                        : const SizedBox(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
