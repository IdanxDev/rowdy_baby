import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrinkScreen extends StatefulWidget {
  final bool isEdit;

  const DrinkScreen({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<DrinkScreen> createState() => DrinkScreenState();
}

class DrinkScreenState extends State<DrinkScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, AppProvider appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Do you\ndrink?',
              fontColor: ColorConstant.pink,
              fontSize: 40,
              maxLines: 2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 34),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: drinkList.length,
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
                      if (widget.isEdit) {
                        Navigator.pop(context, drinkList[index]);
                      } else {
                        appProvider.changeDrinking(index);
                        appProvider.userModel.drink = drinkList[index];
                      }
                    },
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    title: AppText(
                      text: drinkList[index],
                      fontSize: 20,
                      fontColor: appProvider.selectedDrinking == index
                          ? ColorConstant.darkPink
                          : ColorConstant.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                    trailing: appProvider.selectedDrinking == index
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
