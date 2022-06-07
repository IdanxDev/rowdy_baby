import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  State<GenderScreen> createState() => GenderScreenState();
}

class GenderScreenState extends State<GenderScreen> {
  List<String> gender = ['Male', 'Female', 'Others'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: AppText(
                text: 'Gender',
                fontColor: ColorConstant.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 46),
            ListView.separated(
              primary: true,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              itemCount: gender.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: provider.selectedGender == index ? 4 : 0,
                  shadowColor: ColorConstant.dropShadow,
                  color: provider.selectedGender == index
                      ? ColorConstant.white
                      : ColorConstant.darkPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 58,
                    child: ListTile(
                      onTap: () {
                        provider.changeGender(index);
                        provider.userModel.gender = gender[index];
                      },
                      minLeadingWidth: 0,
                      title: AppText(
                        text: gender[index],
                        fontSize: 20,
                        fontColor: provider.selectedGender == index
                            ? ColorConstant.yellow
                            : ColorConstant.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                      trailing: provider.selectedGender == index
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
