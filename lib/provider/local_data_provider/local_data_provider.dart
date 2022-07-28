// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dating/model/city_model.dart';
import 'package:dating/provider/disposable_provider/disposable_provider.dart';
import 'package:dating/service/rest_service.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';

class LocalDataProvider extends DisposableProvider {
  List<String> countryList = [];
  List<String> cityList = [];

  Future<void> getCountries(BuildContext context) async {
    if (countryList.isEmpty) {
      String? getCountries = await RestServices.getCountryRestCall(context);
      if (getCountries != null && getCountries.isNotEmpty) {
        Map<String, dynamic> getCountryMap = jsonDecode(getCountries);
        if (getCountryMap['error']) {
          showMessage(context, message: getCountryMap['msg'], isError: true);
        } else {
          for (var element in getCountryMap['data']) {
            countryList.add(element['country']);
          }
        }
        logs('Country list --> $countryList');
        notifyListeners();
      }
    }
  }

  Future<void> getCities(BuildContext context, String countryName,
      {bool clearList = true}) async {
    String? getCities =
        await RestServices.getCityRestCall(context, countryName: countryName);
    if (getCities != null && getCities.isNotEmpty) {
      CityModel getCityMap = cityModelFromJson(getCities);
      if (getCityMap.error) {
        showMessage(context, message: getCityMap.message, isError: true);
      } else {
        if (clearList) {
          cityList.clear();
        }
        cityList.addAll(getCityMap.data!);
      }
      logs('City list --> $cityList');
      notifyListeners();
    }
  }

  @override
  void disposeAllValues() {
    // TODO: implement disposeAllValues
  }

  @override
  void disposeValues() {
    countryList = [];
    cityList = [];
  }
}
