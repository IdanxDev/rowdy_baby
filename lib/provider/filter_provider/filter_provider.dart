import 'package:dating/model/multi_selection_model.dart';
import 'package:dating/provider/disposable_provider/disposable_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';

class FilterProvider extends DisposableProvider {
  Map<String, dynamic> filterMap = {};
  int selectedGender = UserProfileProvider().interestGender;
  double startAge = 18;
  double endAge = 40;
  double startHeight = 4.0;
  double endHeight = 6.5;
  bool isCountryScreen = false;
  bool isCityScreen = false;
  bool isCastScreen = false;
  bool isReligionScreen = false;
  List<MultiSelectionModel> maritalStatusList = <MultiSelectionModel>[
    MultiSelectionModel(name: 'Single'),
    MultiSelectionModel(name: 'Single with Kids'),
    MultiSelectionModel(name: 'Divorced'),
    MultiSelectionModel(name: 'Divorced with Kids'),
    MultiSelectionModel(name: 'Widowed'),
    MultiSelectionModel(name: 'Widowed with Kids'),
    MultiSelectionModel(name: 'Separated'),
    MultiSelectionModel(name: 'Separated with Kids'),
  ];
  List<MultiSelectionModel> smokeStatusList = <MultiSelectionModel>[
    MultiSelectionModel(name: 'Yes'),
    MultiSelectionModel(name: 'No'),
    MultiSelectionModel(name: 'Planning to quit'),
    MultiSelectionModel(name: 'Occasionally')
  ];
  List<MultiSelectionModel> drinkStatusList = <MultiSelectionModel>[
    MultiSelectionModel(name: 'Yes'),
    MultiSelectionModel(name: 'No'),
    MultiSelectionModel(name: 'Planning to quit'),
    MultiSelectionModel(name: 'Occasionally')
  ];
  List<MultiSelectionModel> educationStatusList = <MultiSelectionModel>[
    MultiSelectionModel(name: 'Graduate degree'),
    MultiSelectionModel(name: 'Undergraduate degree'),
    MultiSelectionModel(name: 'In college'),
    MultiSelectionModel(name: 'In grad school'),
    MultiSelectionModel(name: 'High school'),
    MultiSelectionModel(name: 'Vocational school'),
    MultiSelectionModel(name: 'I\'m not study'),
    MultiSelectionModel(name: 'Quit studies'),
  ];
  List<MultiSelectionModel> languageList = [
    MultiSelectionModel(name: 'English'),
    MultiSelectionModel(name: 'Hindi'),
    MultiSelectionModel(name: 'Telugu'),
    MultiSelectionModel(name: 'Tamil'),
    MultiSelectionModel(name: 'Urdu'),
    MultiSelectionModel(name: 'Bengali'),
    MultiSelectionModel(name: 'Punjabi'),
    MultiSelectionModel(name: 'Malayalam'),
    MultiSelectionModel(name: 'Nepali'),
    MultiSelectionModel(name: 'Manipuri'),
    MultiSelectionModel(name: 'Odia'),
    MultiSelectionModel(name: 'Kannada'),
    MultiSelectionModel(name: 'Sindhi'),
  ];
  List<MultiSelectionModel> usageTypeList = [
    MultiSelectionModel(name: 'A Relationship or date'),
    MultiSelectionModel(name: 'To get marry'),
    MultiSelectionModel(name: 'I\'m not sure'),
    MultiSelectionModel(name: 'Something Casual'),
  ];
  List<String> selectedCountry = <String>[];
  List<String> selectedCity = <String>[];
  List<String> selectedCast = <String>[];
  List<String> selectedReligion = <String>[];
  List<String> selectedMaritalStatus = <String>[];
  List<String> selectedSmokeStatus = <String>[];
  List<String> selectedDrinkStatus = <String>[];
  List<String> selectedEducationStatus = <String>[];
  List<String> selectedLanguageStatus = <String>[];
  List<String> selectedUsageTypeStatus = <String>[];
  final TextEditingController subCastController = TextEditingController();

  void changeGender(int index) {
    selectedGender = index;
    notifyListeners();
  }

  void changeCast(MultiSelectionModel castList) {
    castList.isSelected = !castList.isSelected;
    if (castList.name != 'Open to all') {
      if (castList.isSelected && !selectedCast.contains(castList.name)) {
        selectedCast.add(castList.name!);
      } else {
        selectedCast.remove(castList.name);
      }
    } else {
      selectedCast.clear();
      if (castList.isSelected && !selectedCast.contains(castList.name)) {
        selectedCast.add(castList.name!);
      } else {
        selectedCast.remove(castList.name);
      }
    }
    notifyListeners();
  }

  void changeReligion(MultiSelectionModel selectedReligions) {
    selectedReligions.isSelected = !selectedReligions.isSelected;
    if (selectedReligions.name != 'Open to all') {
      if (selectedReligions.isSelected &&
          !selectedReligion.contains(selectedReligions.name)) {
        selectedReligion.add(selectedReligions.name!);
      } else {
        selectedReligion.remove(selectedReligions.name);
      }
    } else {
      selectedReligion.clear();
      if (selectedReligions.isSelected &&
          !selectedReligion.contains(selectedReligions.name)) {
        selectedReligion.add(selectedReligions.name!);
      } else {
        selectedReligion.remove(selectedReligions.name);
      }
    }
    notifyListeners();
  }

  void selectAgeRange(RangeValues rangeValues) {
    startAge = rangeValues.start;
    endAge = rangeValues.end;
    notifyListeners();
  }

  void selectHeightRange(RangeValues values) {
    startHeight = values.start;
    endHeight = values.end;
    notifyListeners();
  }

  void addCountry(MultiSelectionModel maritalStatus, BuildContext context) {
    maritalStatus.isSelected = !maritalStatus.isSelected;
    if (maritalStatus.isSelected &&
        !selectedCountry.contains(maritalStatus.name)) {
      if (selectedCountry.isEmpty) {
        selectedCountry.add(maritalStatus.name!);
      } else {
        maritalStatus.isSelected = !maritalStatus.isSelected;
        showMessage(context,
            message: 'You can only select one country', isError: true);
      }
    } else {
      selectedCountry.remove(maritalStatus.name);
    }
    notifyListeners();
  }

  void addCity(MultiSelectionModel maritalStatus, BuildContext context) {
    maritalStatus.isSelected = !maritalStatus.isSelected;
    if (maritalStatus.isSelected &&
        !selectedCity.contains(maritalStatus.name)) {
      if (selectedCity.isEmpty) {
        selectedCity.add(maritalStatus.name!);
      } else {
        maritalStatus.isSelected = !maritalStatus.isSelected;
        showMessage(context,
            message: 'You can only select one city', isError: true);
      }
    } else {
      selectedCity.remove(maritalStatus.name);
    }
    notifyListeners();
  }

  void addMaritalStatus(MultiSelectionModel maritalStatus) {
    maritalStatus.isSelected = !maritalStatus.isSelected;
    if (maritalStatus.isSelected &&
        !selectedMaritalStatus.contains(maritalStatus.name)) {
      selectedMaritalStatus.add(maritalStatus.name!);
    } else {
      selectedMaritalStatus.remove(maritalStatus.name);
    }
    notifyListeners();
  }

  void addSmokingStatus(MultiSelectionModel smokingStatus) {
    smokingStatus.isSelected = !smokingStatus.isSelected;
    if (smokingStatus.isSelected &&
        !selectedSmokeStatus.contains(smokingStatus.name)) {
      selectedSmokeStatus.add(smokingStatus.name!);
    } else {
      selectedSmokeStatus.remove(smokingStatus.name);
    }
    notifyListeners();
  }

  void addDrinkingStatus(MultiSelectionModel drinkStatus) {
    drinkStatus.isSelected = !drinkStatus.isSelected;
    if (drinkStatus.isSelected &&
        !selectedDrinkStatus.contains(drinkStatus.name)) {
      selectedDrinkStatus.add(drinkStatus.name!);
    } else {
      selectedDrinkStatus.remove(drinkStatus.name);
    }
    notifyListeners();
  }

  void addEducationStatus(MultiSelectionModel educationStatus) {
    educationStatus.isSelected = !educationStatus.isSelected;
    if (educationStatus.isSelected &&
        !selectedEducationStatus.contains(educationStatus.name)) {
      selectedEducationStatus.add(educationStatus.name!);
    } else {
      selectedEducationStatus.remove(educationStatus.name);
    }
    notifyListeners();
  }

  void addLanguage(MultiSelectionModel languageStatus) {
    languageStatus.isSelected = !languageStatus.isSelected;
    if (languageStatus.isSelected &&
        !selectedLanguageStatus.contains(languageStatus.name)) {
      selectedLanguageStatus.add(languageStatus.name!);
    } else {
      selectedLanguageStatus.remove(languageStatus.name);
    }
    notifyListeners();
  }

  void addUsageStatus(MultiSelectionModel usageTypeStatus) {
    usageTypeStatus.isSelected = !usageTypeStatus.isSelected;
    if (usageTypeStatus.isSelected &&
        !selectedUsageTypeStatus.contains(usageTypeStatus.name)) {
      selectedUsageTypeStatus.add(usageTypeStatus.name!);
    } else {
      selectedUsageTypeStatus.remove(usageTypeStatus.name);
    }
    notifyListeners();
  }

  @override
  void disposeAllValues() {
    // TODO: implement disposeAllValues
  }

  @override
  void disposeValues() {
    filterMap = {};
    selectedGender = UserProfileProvider().interestGender;
    startAge = 18;
    endAge = 40;
    startHeight = 4.0;
    endHeight = 6.5;
    isCountryScreen = false;
    isCityScreen = false;
    isCastScreen = false;
    isReligionScreen = false;
    selectedCountry = <String>[];
    selectedCity = <String>[];
    selectedCast = <String>[];
    selectedReligion = <String>[];
    selectedMaritalStatus = <String>[];
    selectedSmokeStatus = <String>[];
    selectedDrinkStatus = <String>[];
    selectedEducationStatus = <String>[];
    selectedLanguageStatus = <String>[];
    selectedUsageTypeStatus = <String>[];
  }
}
