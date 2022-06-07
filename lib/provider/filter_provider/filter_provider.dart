import 'package:dating/model/multi_selection_model.dart';
import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  int selectedGender = 0;
  double startAge = 18;
  double endAge = 34;
  double startHeight = 4.0;
  double endHeight = 5.0;
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
  List<String> selectedCast = <String>[];
  List<String> selectedReligion = <String>[];

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

  void addMaritalStatus(MultiSelectionModel maritalStatus) {
    maritalStatus.isSelected = !maritalStatus.isSelected;
    maritalStatusList.add(maritalStatus);
    notifyListeners();
  }

  void addSmokingStatus(MultiSelectionModel smokingStatus) {
    smokingStatus.isSelected = !smokingStatus.isSelected;
    smokeStatusList.add(smokingStatus);
    notifyListeners();
  }

  void addDrinkingStatus(MultiSelectionModel drinkStatus) {
    drinkStatus.isSelected = !drinkStatus.isSelected;
    drinkStatusList.add(drinkStatus);
    notifyListeners();
  }

  void addEducationStatus(MultiSelectionModel educationStatus) {
    educationStatus.isSelected = !educationStatus.isSelected;
    educationStatusList.add(educationStatus);
    notifyListeners();
  }

  void addLanguage(MultiSelectionModel languageStatus) {
    languageStatus.isSelected = !languageStatus.isSelected;
    languageList.add(languageStatus);
    notifyListeners();
  }

  void addUsageStatus(MultiSelectionModel usageTypeStatus) {
    usageTypeStatus.isSelected = !usageTypeStatus.isSelected;
    usageTypeList.add(usageTypeStatus);
    notifyListeners();
  }
}
