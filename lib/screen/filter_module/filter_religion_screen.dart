import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/multi_selection_model.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterReligionScreen extends StatefulWidget {
  const FilterReligionScreen({Key? key}) : super(key: key);

  @override
  State<FilterReligionScreen> createState() => FilterReligionScreenState();
}

class FilterReligionScreenState extends State<FilterReligionScreen> {
  final TextEditingController searchController = TextEditingController();
  List<MultiSelectionModel> tmpReligionList = <MultiSelectionModel>[];
  List<MultiSelectionModel> religionList = [
    MultiSelectionModel(name: 'Open to all'),
    MultiSelectionModel(name: 'Christians'),
    MultiSelectionModel(name: 'Muslims'),
    MultiSelectionModel(name: 'Hindus'),
    MultiSelectionModel(name: 'Chinese'),
    MultiSelectionModel(name: 'Buddhists'),
    MultiSelectionModel(name: 'Sikhs'),
    MultiSelectionModel(name: 'Jains'),
    MultiSelectionModel(name: 'Jews'),
    MultiSelectionModel(name: 'Spiritists'),
    MultiSelectionModel(name: 'Atheist'),
    MultiSelectionModel(name: 'zoroastrians'),
    MultiSelectionModel(name: 'Shintoists'),
    MultiSelectionModel(name: 'Bha\'is'),
    MultiSelectionModel(name: 'Neoreligionists'),
    MultiSelectionModel(name: 'Ethnoreligionists'),
  ];

  @override
  void initState() {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    for (String element in filterProvider.selectedReligion) {
      for (MultiSelectionModel castElement in religionList) {
        if (element == castElement.name) {
          castElement.isSelected = true;
        }
      }
    }
    tmpReligionList.addAll(religionList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, FilterProvider filterProvider, child) {
        return Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: ColorConstant.pink,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 32),
                child: AppText(
                  text: 'What\'s your Religion?',
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
                    hintText: 'Search religion',
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: AppImageAsset(
                        image: ImageConstant.searchIcon,
                      ),
                    ),
                  ),
                  onChanged: (caste) {
                    religionList = tmpReligionList;
                    religionList = religionList
                        .where((element) => element.name!
                            .toLowerCase()
                            .contains(caste.toLowerCase()))
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
                itemCount: religionList.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 58,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0XFFE63060)),
                      ),
                    ),
                    child: ListTile(
                      onTap: () =>
                          filterProvider.changeReligion(religionList[index]),
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      title: AppText(
                        text: religionList[index].name,
                        fontSize: 20,
                        fontColor: (religionList[0].isSelected ||
                                religionList[index].isSelected)
                            ? ColorConstant.lightYellow
                            : ColorConstant.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                      trailing: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: (religionList[0].isSelected ||
                                  religionList[index].isSelected)
                              ? ColorConstant.lightYellow
                              : ColorConstant.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: (religionList[0].isSelected ||
                                    religionList[index].isSelected)
                                ? ColorConstant.transparent
                                : ColorConstant.white,
                          ),
                        ),
                        child: (religionList[0].isSelected ||
                                religionList[index].isSelected)
                            ? const Icon(Icons.done,
                                size: 16, color: ColorConstant.white)
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
          ),
        );
      },
    );
  }
}
