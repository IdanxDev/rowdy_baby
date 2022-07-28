import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/multi_selection_model.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterCityScreen extends StatefulWidget {
  const FilterCityScreen({Key? key}) : super(key: key);

  @override
  State<FilterCityScreen> createState() => FilterCityScreenState();
}

class FilterCityScreenState extends State<FilterCityScreen> {
  final TextEditingController searchController = TextEditingController();
  List<MultiSelectionModel> cityList = <MultiSelectionModel>[];
  List<MultiSelectionModel> tmpCityList = <MultiSelectionModel>[];
  bool isLoading = true;

  @override
  void initState() {
    getCityList();
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
                  text: 'What\'s your city?',
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
                    hintText: 'Search city',
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: AppImageAsset(
                        image: ImageConstant.searchIcon,
                      ),
                    ),
                  ),
                  onChanged: (caste) {
                    cityList = tmpCityList;
                    cityList = cityList
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
                itemCount: cityList.length,
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
                          onTap: () => provider.addCity(cityList[index], context),
                          minLeadingWidth: 0,
                          minVerticalPadding: 0,
                          title: AppText(
                            text: cityList[index].name,
                            fontSize: 20,
                            fontColor: cityList[index].isSelected
                                ? ColorConstant.lightYellow
                                : ColorConstant.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                          trailing: cityList[index].isSelected
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
            ? const AppImageLoader(loadingText: 'Fetching cities')
            : const SizedBox(),
      ],
    );
  }

  Future<void> getCityList() async {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    final localDataProvider = Provider.of<LocalDataProvider>(context, listen: false);
    await localDataProvider.getCities(context, filterProvider.selectedCountry[0]);
    logs('loop City list --> $cityList');
    for (String element in localDataProvider.cityList) {
      cityList.add(MultiSelectionModel(name: element));
    }
    logs('loop City list after --> $cityList');
    await selectCity();
  }

  Future<void> selectCity() async {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    for (String element in filterProvider.selectedCity) {
      for (MultiSelectionModel castElement in cityList) {
        if (element == castElement.name) {
          castElement.isSelected = true;
        }
      }
    }
    tmpCityList.addAll(cityList);
    isLoading = false;
    setState(() {});
  }
}
