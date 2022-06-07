import 'package:dating/model/multi_selection_model.dart';
import 'package:dating/model/user_model.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int currentIndex = 0;
  int selectedProfileIndex = 0;
  int selectedPersonalIndex = 0;
  int selectedGender = -1;
  int selectedInterest = -1;
  int selectedCast = -1;
  int selectedRegion = -1;
  int selectedUsageType = -1;
  int selectedHeight = -1;
  int selectedMaritalStatus = -1;
  int selectedSmokingType = -1;
  int selectedDrinking = -1;
  int selectedEducation = -1;
  DateTime? birthDate;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobNameController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  String? loginNumber;
  String userId = '';
  int aboutCharacter = 300;
  int maxCharacter = 300;
  List<MultiSelectionModel> selectedLanguage = <MultiSelectionModel>[];
  List<String> userPhotos = <String>['', '', '', '', '', ''];
  int bottomNavBarIndex = 0;
  UserModel userModel = UserModel();

  void changeSlider() {
    if (currentIndex != 2) {
      currentIndex++;
    } else {
      currentIndex = 0;
    }
    notifyListeners();
  }

  void changeProfileScreen(int index) {
    selectedProfileIndex = index;
    notifyListeners();
  }

  void changePersonalScreen(int index) {
    selectedPersonalIndex = index;
    notifyListeners();
  }

  void changeBottomNavBar(int index) {
    bottomNavBarIndex = index;
    notifyListeners();
  }

  void changeGender(int index) {
    selectedGender = index;
    notifyListeners();
  }

  void changeInterest(int index) {
    selectedInterest = index;
    notifyListeners();
  }

  void changeCast(int index) {
    selectedCast = index;
    notifyListeners();
  }

  void changeReligion(int index) {
    selectedRegion = index;
    notifyListeners();
  }

  void changeUsageType(int index) {
    selectedUsageType = index;
    notifyListeners();
  }

  void changeHeight(int index) {
    selectedHeight = index;
    notifyListeners();
  }

  void changeMaritalStatus(int index) {
    selectedMaritalStatus = index;
    notifyListeners();
  }

  void changeSmoking(int index) {
    selectedSmokingType = index;
    notifyListeners();
  }

  void changeDrinking(int index) {
    selectedDrinking = index;
    notifyListeners();
  }

  void changeLanguage(MultiSelectionModel languageList) {
    languageList.isSelected = !languageList.isSelected;
    if (languageList.isSelected && !selectedLanguage.contains(languageList)) {
      selectedLanguage.add(languageList);
    } else {
      selectedLanguage
          .removeWhere((element) => element.name == languageList.name);
    }
    notifyListeners();
  }

  void changeEducation(int index) {
    selectedEducation = index;
    notifyListeners();
  }
}
