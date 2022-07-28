import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterestScreen extends StatefulWidget {
  final bool isEdit;

  const InterestScreen({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<InterestScreen> createState() => InterestScreenState();
}

class InterestScreenState extends State<InterestScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: AppText(
                text: 'Who are you Interested in ?',
                fontColor: ColorConstant.white,
                fontSize: 40,
                maxLines: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 46),
            ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              itemCount: interestTypeList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: provider.selectedInterest == index ? 4 : 0,
                  shadowColor: ColorConstant.dropShadow,
                  color: provider.selectedInterest == index
                      ? ColorConstant.white
                      : ColorConstant.darkPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 58,
                    child: ListTile(
                      onTap: () {
                        if (widget.isEdit) {
                          Navigator.pop(context, interestTypeList[index]);
                        } else {
                          provider.changeInterest(index);
                          provider.userModel.interest = interestTypeList[index];
                        }
                      },
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      title: AppText(
                        text: interestTypeList[index],
                        fontSize: 18,
                        fontColor: provider.selectedInterest == index
                            ? ColorConstant.yellow
                            : ColorConstant.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                      trailing: provider.selectedInterest == index
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
