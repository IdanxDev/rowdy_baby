import 'package:dating/constant/color_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({Key? key}) : super(key: key);

  @override
  State<CityListScreen> createState() => CityListScreenState();
}

class CityListScreenState extends State<CityListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'City',
              fontColor: ColorConstant.pink,
              fontSize: 40,
              maxLines: 2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 34),
            Consumer<LocalDataProvider>(
              builder: (context, localProvider, child) {
                return TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: provider.cityController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Select city',
                      hintStyle: const TextStyle(color: ColorConstant.grey),
                      contentPadding: const EdgeInsets.fromLTRB(24, 18, 12, 18),
                      fillColor: ColorConstant.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: ColorConstant.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: ColorConstant.grey),
                      ),
                    ),
                  ),
                  onSuggestionSelected: (city) {
                    logs('select --> $city');
                    provider.cityController.text = city.toString();
                  },
                  itemBuilder: (context, itemData) {
                    return ListTile(
                      title: AppText(
                        text: itemData.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        fontSize: 16,
                        fontColor: ColorConstant.black,
                      ),
                    );
                  },
                  suggestionsCallback: (cityName) {
                    return localSearch(cityName, localProvider.cityList);
                  },
                  noItemsFoundBuilder: (context) => const ListTile(
                    title: AppText(
                      text: 'Oops, City not found',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      fontSize: 16,
                      fontColor: ColorConstant.black,
                    ),
                  ),
                  hideOnError: true,
                );
              },
            ),
          ],
        );
      },
    );
  }

  localSearch(String cityName, List<String> cityList) {
    List<String> sortedCountry = [];
    sortedCountry = cityList
        .where(
            (element) => element.toLowerCase().contains(cityName.toLowerCase()))
        .toList();
    return sortedCountry;
  }
}
