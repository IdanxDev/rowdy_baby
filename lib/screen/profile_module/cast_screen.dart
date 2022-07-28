import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/utils/local_list.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CastScreen extends StatefulWidget {
  final bool isEdit;

  const CastScreen({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<CastScreen> createState() => CastScreenState();
}

class CastScreenState extends State<CastScreen> {
  final TextEditingController searchController = TextEditingController();
  List<String> tmpCastTypeList = <String>[];

  @override
  void initState() {
    tmpCastTypeList.addAll(castTypeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, AppProvider appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: AppText(
                text: 'What\'s your caste?',
                fontColor: ColorConstant.white,
                fontSize: 40,
                maxLines: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextFormField(
                controller: searchController,
                style: const TextStyle(
                  fontFamily: AppTheme.defaultFont,
                  fontSize: 16,
                  color: ColorConstant.white,
                  letterSpacing: 0.48,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search caste',
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(16),
                    child: AppImageAsset(
                      image: ImageConstant.searchIcon,
                    ),
                  ),
                ),
                onChanged: (caste) {
                  castTypeList = tmpCastTypeList;
                  castTypeList = castTypeList
                      .where((element) =>
                          element.toLowerCase().contains(caste.toLowerCase()))
                      .toList();
                  setState(() {});
                },
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
              ),
            ),
            const SizedBox(height: 34),
            ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              itemCount: castTypeList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 58,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0XFFE63060)),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      if (widget.isEdit) {
                        Navigator.pop(context, castTypeList[index]);
                      } else {
                        appProvider.changeCast(index);
                        appProvider.userModel.cast = castTypeList[index];
                      }
                    },
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    title: AppText(
                      text: castTypeList[index],
                      fontSize: 20,
                      fontColor: appProvider.selectedCast == index
                          ? ColorConstant.lightYellow
                          : ColorConstant.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                    trailing: appProvider.selectedCast == index
                        ? const AppImageAsset(
                            image: ImageConstant.yellowTickIcon)
                        : const SizedBox(),
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
