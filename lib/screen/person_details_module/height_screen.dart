import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeightScreen extends StatefulWidget {
  final bool isEdit;

  const HeightScreen({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<HeightScreen> createState() => HeightScreenState();
}

class HeightScreenState extends State<HeightScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, AppProvider appProvider, child) {
        return Column(
          children: [
            const AppText(
              text: 'What\'s your height ?',
              fontColor: ColorConstant.pink,
              fontSize: 40,
              maxLines: 2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 34),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: heightList.length,
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
                        Navigator.pop(context, heightList[index]);
                      } else {
                        appProvider.changeHeight(index);
                        appProvider.userModel.height = heightList[index];
                      }
                    },
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    title: AppText(
                      text: heightList[index],
                      fontSize: 20,
                      fontColor: appProvider.selectedHeight == index
                          ? ColorConstant.darkPink
                          : ColorConstant.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                    trailing: appProvider.selectedHeight == index
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
