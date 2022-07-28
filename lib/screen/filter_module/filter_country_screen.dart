import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/multi_selection_model.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterCountryScreen extends StatefulWidget {
  const FilterCountryScreen({Key? key}) : super(key: key);

  @override
  State<FilterCountryScreen> createState() => FilterCountryScreenState();
}

class FilterCountryScreenState extends State<FilterCountryScreen> {
  final TextEditingController searchController = TextEditingController();
  List<MultiSelectionModel> countryList = <MultiSelectionModel>[];
  List<MultiSelectionModel> tmpCountryList = <MultiSelectionModel>[];
  bool isLoading = true;

  @override
  void initState() {
    getCountryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          decoration: const BoxDecoration(color: ColorConstant.pink),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 32),
                child: AppText(
                  text: 'What\'s your country?',
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
                    hintText: 'Search country',
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: AppImageAsset(
                        image: ImageConstant.searchIcon,
                      ),
                    ),
                  ),
                  onChanged: (caste) {
                    countryList = tmpCountryList;
                    countryList = countryList
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
                itemCount: countryList.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 58,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0XFFE63060)),
                      ),
                    ),
                    child: Consumer<FilterProvider>(
                      builder: (context, provider, child) {
                        return ListTile(
                          onTap: () => provider.addCountry(countryList[index], context),
                          minLeadingWidth: 0,
                          minVerticalPadding: 0,
                          title: AppText(
                            text: countryList[index].name,
                            fontSize: 20,
                            fontColor: countryList[index].isSelected
                                ? ColorConstant.lightYellow
                                : ColorConstant.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                          trailing: countryList[index].isSelected
                              ? const AppImageAsset(image: ImageConstant.yellowTickIcon)
                              : const SizedBox(),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
              ),
            ],
          ),
        ),
        isLoading
            ? const AppImageLoader(loadingText: 'Fetching countries')
            : const SizedBox(),
      ],
    );
  }

  Future<void> getCountryList() async {
    final localDataProvider =
        Provider.of<LocalDataProvider>(context, listen: false);
    localDataProvider.countryList.clear();
    await localDataProvider.getCountries(context);
    for (String element in localDataProvider.countryList) {
      countryList.add(MultiSelectionModel(name: element));
    }
    await selectCountry();
  }

  Future<void> selectCountry() async {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    for (String element in filterProvider.selectedCountry) {
      for (MultiSelectionModel castElement in countryList) {
        if (element == castElement.name) {
          castElement.isSelected = true;
        }
      }
    }
    tmpCountryList.addAll(countryList);
    isLoading = false;
    setState(() {});
  }
}
