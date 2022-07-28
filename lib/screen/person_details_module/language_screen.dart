import 'package:dating/constant/color_constant.dart';
import 'package:dating/model/multi_selection_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  final bool isEdit;

  const LanguageScreen({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<LanguageScreen> createState() => LanguageScreenState();
}

class LanguageScreenState extends State<LanguageScreen> {
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
    MultiSelectionModel(name: 'Angika'),
    MultiSelectionModel(name: 'Arunachali'),
    MultiSelectionModel(name: 'Assamese'),
    MultiSelectionModel(name: 'Awadhi'),
    MultiSelectionModel(name: 'Bengali'),
    MultiSelectionModel(name: 'Bhojpuri'),
    MultiSelectionModel(name: 'Brij'),
    MultiSelectionModel(name: 'Bihari'),
    MultiSelectionModel(name: 'Badaga'),
    MultiSelectionModel(name: 'Chatisgarhi'),
    MultiSelectionModel(name: 'Dogri'),
    MultiSelectionModel(name: 'English'),
    MultiSelectionModel(name: 'French'),
    MultiSelectionModel(name: 'Garhwali'),
    MultiSelectionModel(name: 'Garo'),
    MultiSelectionModel(name: 'Gujarati'),
    MultiSelectionModel(name: 'Haryanvi'),
    MultiSelectionModel(name: 'Himachali/Pahari'),
    MultiSelectionModel(name: 'Hindi'),
    MultiSelectionModel(name: 'Kanauji'),
    MultiSelectionModel(name: 'Kannada'),
    MultiSelectionModel(name: 'Kashmiri'),
    MultiSelectionModel(name: 'Khandesi'),
    MultiSelectionModel(name: 'Khasi'),
    MultiSelectionModel(name: 'Konkani'),
    MultiSelectionModel(name: 'Koshali'),
    MultiSelectionModel(name: 'Kumaoni'),
    MultiSelectionModel(name: 'Kutchi'),
    MultiSelectionModel(name: 'Lepcha'),
    MultiSelectionModel(name: 'Ladacki'),
    MultiSelectionModel(name: 'Magahi'),
    MultiSelectionModel(name: 'Maithili'),
    MultiSelectionModel(name: 'Malayalam'),
    MultiSelectionModel(name: 'Manipuri'),
    MultiSelectionModel(name: 'Marathi'),
    MultiSelectionModel(name: 'Marwari'),
    MultiSelectionModel(name: 'Miji'),
    MultiSelectionModel(name: 'Mizo'),
    MultiSelectionModel(name: 'Monpa'),
    MultiSelectionModel(name: 'Nicobarese'),
    MultiSelectionModel(name: 'Nepali'),
    MultiSelectionModel(name: 'Oriya'),
    MultiSelectionModel(name: 'Punjabi'),
    MultiSelectionModel(name: 'Rajasthani'),
    MultiSelectionModel(name: 'Sanskrit'),
    MultiSelectionModel(name: 'Santhali'),
    MultiSelectionModel(name: 'Sindhi'),
    MultiSelectionModel(name: 'Sourashtra'),
    MultiSelectionModel(name: 'Tamil'),
    MultiSelectionModel(name: 'Telugu'),
    MultiSelectionModel(name: 'Tripuri'),
    MultiSelectionModel(name: 'Tulu'),
    MultiSelectionModel(name: 'Urdu'),
    MultiSelectionModel(name: 'BagriRajasthani'),
    MultiSelectionModel(name: 'Dhundhari/Jaipuri'),
    MultiSelectionModel(name: 'Gujari/Gojari'),
    MultiSelectionModel(name: 'Harauti'),
    MultiSelectionModel(name: 'Lambadi'),
    MultiSelectionModel(name: 'Malvi'),
    MultiSelectionModel(name: 'Mewari'),
    MultiSelectionModel(name: 'Mewati/Ahirwati'),
    MultiSelectionModel(name: 'Nimadi'),
    MultiSelectionModel(name: 'Shekhawati'),
    MultiSelectionModel(name: 'Wagdi'),
  ];

  @override
  void initState() {
    if (widget.isEdit) {
      getSelectedLanguage();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, AppProvider appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Languages speak?',
              fontColor: ColorConstant.pink,
              fontSize: 40,
              maxLines: 2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 34),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: languageList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 58,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0XFFF2F2F2)),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      appProvider.changeLanguage(languageList[index]);
                      List<String> selectedLanguage = <String>[];
                      for (MultiSelectionModel element in languageList) {
                        if (element.isSelected) {
                          selectedLanguage.add(element.name!);
                        }
                      }
                      appProvider.userModel.language = selectedLanguage;
                    },
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    title: AppText(
                      text: languageList[index].name,
                      fontSize: 20,
                      fontColor: languageList[index].isSelected
                          ? ColorConstant.darkPink
                          : ColorConstant.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                    trailing: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: languageList[index].isSelected
                            ? ColorConstant.pink
                            : ColorConstant.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: languageList[index].isSelected
                              ? ColorConstant.transparent
                              : ColorConstant.dropShadow,
                        ),
                      ),
                      child: languageList[index].isSelected
                          ? const Icon(Icons.done,
                              size: 16, color: ColorConstant.white)
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void getSelectedLanguage() {
    final profileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    List<String>? languages = profileProvider.currentUserData!.language;
    if (languages != null) {
      for (MultiSelectionModel element in languageList) {
        for (String elements in languages) {
          if (element.name!.toLowerCase() == elements.toLowerCase()) {
            element.isSelected = true;
          }
        }
      }
    }
    setState(() {});
  }
}
