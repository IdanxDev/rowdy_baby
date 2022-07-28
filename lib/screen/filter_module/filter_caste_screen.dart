import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/multi_selection_model.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterCastScreen extends StatefulWidget {
  const FilterCastScreen({Key? key}) : super(key: key);

  @override
  State<FilterCastScreen> createState() => FilterCastScreenState();
}

class FilterCastScreenState extends State<FilterCastScreen> {
  final TextEditingController searchController = TextEditingController();
  List<MultiSelectionModel> tmpCastTypeList = <MultiSelectionModel>[];
  List<MultiSelectionModel> castTypeList = [
    MultiSelectionModel(name: 'Open to all'),
    MultiSelectionModel(name: 'Agarwal'),
    MultiSelectionModel(name: 'Arora'),
    MultiSelectionModel(name: 'Baniya'),
    MultiSelectionModel(name: 'Brahmin'),
    MultiSelectionModel(name: 'Gujarati'),
    MultiSelectionModel(name: 'Gupta'),
    MultiSelectionModel(name: 'Jat'),
    MultiSelectionModel(name: 'Kayastha'),
    MultiSelectionModel(name: 'Khatri'),
    MultiSelectionModel(name: 'Kshatriya'),
    MultiSelectionModel(name: 'Rajput'),
    MultiSelectionModel(name: 'Sindhi'),
    MultiSelectionModel(name: 'vaish'),
    MultiSelectionModel(name: 'Agri'),
    MultiSelectionModel(name: 'Ahom'),
    MultiSelectionModel(name: 'Arekatica'),
    MultiSelectionModel(name: 'Arunthathiyar'),
    MultiSelectionModel(name: 'Arya'),
    MultiSelectionModel(name: 'Vysya'),
    MultiSelectionModel(name: 'Aryasamaj'),
    MultiSelectionModel(name: 'Baidya'),
    MultiSelectionModel(name: 'Baishya'),
    MultiSelectionModel(name: 'Balija'),
    MultiSelectionModel(name: 'Bhandari'),
    MultiSelectionModel(name: 'Bhatia'),
    MultiSelectionModel(name: 'Billava'),
    MultiSelectionModel(name: 'Bunt'),
    MultiSelectionModel(name: 'CKP'),
    MultiSelectionModel(name: 'Chambar'),
    MultiSelectionModel(name: 'Chandravanshi'),
    MultiSelectionModel(name: 'Kahar'),
    MultiSelectionModel(name: 'Chaudary'),
    MultiSelectionModel(name: 'Chaurasia'),
    MultiSelectionModel(name: 'Cheramar'),
    MultiSelectionModel(name: 'Chettiar'),
    MultiSelectionModel(name: 'Devanga'),
    MultiSelectionModel(name: 'Devendra'),
    MultiSelectionModel(name: 'Kula'),
    MultiSelectionModel(name: 'vellalar'),
    MultiSelectionModel(name: 'Dhoba'),
    MultiSelectionModel(name: 'Dhobi'),
    MultiSelectionModel(name: 'Ediga'),
    MultiSelectionModel(name: 'Gandla'),
    MultiSelectionModel(name: 'Garhwali'),
    MultiSelectionModel(name: 'Ghumar'),
    MultiSelectionModel(name: 'Goan'),
    MultiSelectionModel(name: 'Goud'),
    MultiSelectionModel(name: 'Gounder'),
    MultiSelectionModel(name: 'Gowda'),
    MultiSelectionModel(name: 'Jaiswal'),
    MultiSelectionModel(name: 'Jatav'),
    MultiSelectionModel(name: 'Kalar'),
    MultiSelectionModel(name: 'Kalita'),
    MultiSelectionModel(name: 'Kalwar'),
    MultiSelectionModel(name: 'Kamma'),
    MultiSelectionModel(name: 'Kammala'),
    MultiSelectionModel(name: 'Kapu'),
    MultiSelectionModel(name: 'Naidu'),
    MultiSelectionModel(name: 'Karmakar'),
    MultiSelectionModel(name: 'Kasar'),
    MultiSelectionModel(name: 'Kashyap'),
    MultiSelectionModel(name: 'Khandelwal'),
    MultiSelectionModel(name: 'Khatik'),
    MultiSelectionModel(name: 'Koli'),
    MultiSelectionModel(name: 'Konkani'),
    MultiSelectionModel(name: 'Kori'),
    MultiSelectionModel(name: 'Koshti'),
    MultiSelectionModel(name: 'Kumaoni'),
    MultiSelectionModel(name: 'Kumhar'),
    MultiSelectionModel(name: 'Kummari'),
    MultiSelectionModel(name: 'Kunbi'),
    MultiSelectionModel(name: 'Kurava'),
    MultiSelectionModel(name: 'Kuruba'),
    MultiSelectionModel(name: 'Kushwaha'),
    MultiSelectionModel(name: 'Kutchi'),
    MultiSelectionModel(name: 'Lambani'),
    MultiSelectionModel(name: 'Lohan'),
    MultiSelectionModel(name: 'Mahajan'),
    MultiSelectionModel(name: 'Mahar'),
    MultiSelectionModel(name: 'Maharashtrian'),
    MultiSelectionModel(name: 'Maheshwari'),
    MultiSelectionModel(name: 'Mahishya'),
    MultiSelectionModel(name: 'Malayalee'),
    MultiSelectionModel(name: 'Variar'),
    MultiSelectionModel(name: 'Mali'),
    MultiSelectionModel(name: 'Mangalorean'),
    MultiSelectionModel(name: 'Maratha'),
    MultiSelectionModel(name: 'Marvar'),
    MultiSelectionModel(name: 'Marwari'),
    MultiSelectionModel(name: 'Maurya'),
    MultiSelectionModel(name: 'Meena'),
    MultiSelectionModel(name: 'Mehra'),
    MultiSelectionModel(name: 'Menon'),
    MultiSelectionModel(name: 'Mudaliar'),
    MultiSelectionModel(name: 'Munnuru'),
    MultiSelectionModel(name: 'Kapu'),
    MultiSelectionModel(name: 'Nadar'),
    MultiSelectionModel(name: 'Nai'),
    MultiSelectionModel(name: 'Naicker'),
    MultiSelectionModel(name: 'Naidu'),
    MultiSelectionModel(name: 'Nair'),
    MultiSelectionModel(name: 'Namasudra'),
    MultiSelectionModel(name: 'Nayak'),
    MultiSelectionModel(name: 'Nepali'),
    MultiSelectionModel(name: 'Oswal'),
    MultiSelectionModel(name: 'Padmashali'),
    MultiSelectionModel(name: 'Perika'),
    MultiSelectionModel(name: 'Pillai'),
    MultiSelectionModel(name: 'Prajapati'),
    MultiSelectionModel(name: 'Ravidasia'),
    MultiSelectionModel(name: 'Reddy'),
    MultiSelectionModel(name: 'Saini'),
    MultiSelectionModel(name: 'Shah'),
    MultiSelectionModel(name: 'Soni'),
    MultiSelectionModel(name: 'Sowrashtra'),
    MultiSelectionModel(name: 'Sri'),
    MultiSelectionModel(name: 'Vaishnva'),
    MultiSelectionModel(name: 'Sundhi'),
    MultiSelectionModel(name: 'Sutar'),
    MultiSelectionModel(name: 'Swarnakar'),
    MultiSelectionModel(name: 'Tamil'),
    MultiSelectionModel(name: 'Yadava'),
    MultiSelectionModel(name: 'Tamti'),
    MultiSelectionModel(name: 'Teli'),
    MultiSelectionModel(name: 'Telugu'),
    MultiSelectionModel(name: 'Thakkar'),
    MultiSelectionModel(name: 'Thakur'),
    MultiSelectionModel(name: 'Theavar'),
    MultiSelectionModel(name: 'Thiyya'),
    MultiSelectionModel(name: 'Togata'),
    MultiSelectionModel(name: 'Udayar'),
    MultiSelectionModel(name: 'Vadagalai'),
    MultiSelectionModel(name: 'Vaishnav'),
    MultiSelectionModel(name: 'Vaishya'),
    MultiSelectionModel(name: 'Vallala'),
    MultiSelectionModel(name: 'Valmiki'),
    MultiSelectionModel(name: 'Vanniyar'),
    MultiSelectionModel(name: 'Variar'),
    MultiSelectionModel(name: 'Varshney'),
    MultiSelectionModel(name: 'Velar'),
    MultiSelectionModel(name: 'Vishwakarma'),
    MultiSelectionModel(name: 'Vokaliga'),
    MultiSelectionModel(name: 'Vysya'),
    MultiSelectionModel(name: 'Yadav'),
    MultiSelectionModel(name: 'Other Scheduled Caste'),
    MultiSelectionModel(name: 'None'),
  ];

  @override
  void initState() {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    for (String element in filterProvider.selectedCast) {
      for (MultiSelectionModel castElement in castTypeList) {
        if (element == castElement.name) {
          castElement.isSelected = true;
        }
      }
    }
    tmpCastTypeList.addAll(castTypeList);
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
                      onTap: () =>
                          filterProvider.changeCast(castTypeList[index]),
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      title: AppText(
                        text: castTypeList[index].name,
                        fontSize: 20,
                        fontColor: (castTypeList[0].isSelected ||
                                castTypeList[index].isSelected)
                            ? ColorConstant.lightYellow
                            : ColorConstant.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                      trailing: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: (castTypeList[0].isSelected ||
                                  castTypeList[index].isSelected)
                              ? ColorConstant.lightYellow
                              : ColorConstant.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: (castTypeList[0].isSelected ||
                                    castTypeList[index].isSelected)
                                ? ColorConstant.transparent
                                : ColorConstant.white,
                          ),
                        ),
                        child: (castTypeList[0].isSelected ||
                                castTypeList[index].isSelected)
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
