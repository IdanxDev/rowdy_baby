import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CastScreen extends StatefulWidget {
  const CastScreen({Key? key}) : super(key: key);

  @override
  State<CastScreen> createState() => CastScreenState();
}

class CastScreenState extends State<CastScreen> {
  final TextEditingController searchController = TextEditingController();
  List<String> castTypeList = [
    'Agarwal',
    'Arora',
    'Baniya',
    'Brahmin',
    'Gujarati',
    'Gupta',
    'Jat',
    'Kayastha',
    'Khatri',
    'Kshatriya',
    'Rajput',
    'Sindhi',
    'vaish',
    'Agri',
    'Ahom',
    'Arekatica',
    'Arunthathiyar',
    'Arya',
    'Vysya',
    'Aryasamaj',
    'Baidya',
    'Baishya',
    'Balija',
    'Bhandari',
    'Bhatia',
    'Billava',
    'Bunt',
    'CKP',
    'Chambar',
    'Chandravanshi',
    'Kahar',
    'Chaudary',
    'Chaurasia',
    'Cheramar',
    'Chettiar',
    'Devanga',
    'Devendra',
    'Kula',
    'vellalar',
    'Dhoba',
    'Dhobi',
    'Ediga',
    'Gandla',
    'Garhwali',
    'Ghumar',
    'Goan',
    'Goud',
    'Gounder',
    'Gowda',
    'Jaiswal',
    'Jatav',
    'Kalar',
    'Kalita',
    'Kalwar',
    'Kamma',
    'Kammala',
    'Kapu',
    'Naidu',
    'Karmakar',
    'Kasar',
    'Kashyap',
    'Khandelwal',
    'Khatik',
    'Koli',
    'Konkani',
    'Kori',
    'Koshti',
    'Kumaoni',
    'Kumhar',
    'Kummari',
    'Kunbi',
    'Kurava',
    'Kuruba',
    'Kushwaha',
    'Kutchi',
    'Lambani',
    'Lohan',
    'Mahajan',
    'Mahar',
    'Maharashtrian',
    'Maheshwari',
    'Mahishya',
    'Malayalee'
        'Variar',
    'Mali',
    'Mangalorean',
    'Maratha',
    'Marvar',
    'Marwari',
    'Maurya',
    'Meena',
    'Mehra',
    'Menon',
    'Mudaliar',
    'Munnuru'
        'Kapu',
    'Nadar',
    'Nai',
    'Naicker',
    'Naidu',
    'Nair',
    'Namasudra',
    'Nayak',
    'Nepali',
    'Oswal',
    'Padmashali',
    'Perika',
    'Pillai',
    'Prajapati',
    'Ravidasia',
    'Reddy',
    'Saini',
    'Shah',
    'Soni',
    'Sowrashtra',
    'Sri',
    'Vaishnva',
    'Sundhi',
    'Sutar',
    'Swarnakar',
    'Tamil',
    'Yadava',
    'Tamti',
    'Teli',
    'Telugu',
    'Thakkar',
    'Thakur',
    'Theavar',
    'Thiyya',
    'Togata',
    'Udayar',
    'Vadagalai',
    'Vaishnav',
    'Vaishya',
    'Vallala',
    'Valmiki',
    'Vanniyar',
    'Variar',
    'Varshney',
    'Velar',
    'Vishwakarma',
    'Vokaliga',
    'Vysya',
    'Yadav',
    'Other Scheduled Caste',
    'None'
  ];
  List<String> tmpCastTypeList = <String>[];

  @override
  void initState() {
    tmpCastTypeList.addAll(castTypeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, AppProvider appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      .where((element) =>
                          element.toLowerCase().contains(caste.toLowerCase()))
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
                    onTap: () {
                      appProvider.changeCast(index);
                      appProvider.userModel.cast = castTypeList[index];
                    },
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    title: AppText(
                      text: castTypeList[index],
                      fontSize: 20,
                      fontColor: appProvider.selectedCast == index
                          ? ColorConstant.yellow
                          : ColorConstant.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                    trailing: appProvider.selectedCast == index
                        ? const AppImageAsset(
                            image: ImageConstant.yellowTickIcon)
                        : const SizedBox(),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
            ),
          ],
        );
      },
    );
  }
}
