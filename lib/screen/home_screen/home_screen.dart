// ignore_for_file: use_build_context_synchronously

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/bottom_nav_bar_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/filter_module/filter_screen.dart';
import 'package:dating/screen/swipe_screen/swipe_screen.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_bottom_bar/app_bottom_bar.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Widget> homeScreenList = [
    Container(),
    const SwipeScreen(),
    Container(),
    Container(),
  ];

  List<BottomNavBarModel> bottomNavBarList = [
    BottomNavBarModel(
      tabName: 'Profile',
      tabImage: ImageConstant.profileTab,
      selectedTabImage: ImageConstant.colorProfileTab,
    ),
    BottomNavBarModel(
      tabName: 'Swipe',
      tabImage: ImageConstant.cardTab,
      selectedTabImage: ImageConstant.colorCardTab,
    ),
    BottomNavBarModel(
      tabName: 'Babies',
      tabImage: ImageConstant.likeTab,
      selectedTabImage: ImageConstant.colorLikeTab,
    ),
    BottomNavBarModel(
      tabName: 'Chat',
      tabImage: ImageConstant.chatTab,
      selectedTabImage: ImageConstant.colorChatTab,
    ),
  ];

  @override
  void initState() {
    setPrefValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<HomeProvider>(
        builder: (BuildContext context, HomeProvider homeProvider, _) {
          return Consumer<AppProvider>(
            builder: (BuildContext context, AppProvider appProvider, _) {
              return SafeArea(
                child: Scaffold(
                  appBar: buildAppBar(context),
                  body: homeScreenList[appProvider.bottomNavBarIndex],
                  bottomNavigationBar:
                      buildBottomNavBar(appProvider, homeProvider),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Container buildBottomNavBar(
      AppProvider appProvider, HomeProvider homeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.themeScaffold,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.dropShadow.withOpacity(0.8),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: AppBottomBar(
        textStyle: const TextStyle(
          fontFamily: AppTheme.defaultFont,
          color: ColorConstant.pink,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        duration: const Duration(milliseconds: 800),
        onTabChange: (int selectedIndex) {
          appProvider.changeBottomNavBar(selectedIndex);
          homeProvider.isDetails = false;
        },
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        tabs: List.generate(
          bottomNavBarList.length,
          (index) => AppBottomBarButton(
            icon: Icons.home,
            text: appProvider.bottomNavBarIndex == index
                ? bottomNavBarList[index].tabName!
                : '',
            leading: AppImageAsset(
              image: appProvider.bottomNavBarIndex == index
                  ? bottomNavBarList[index].selectedTabImage
                  : bottomNavBarList[index].tabImage,
              height: 24,
              width: 24,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height * 2),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const AppImageAsset(
              image: ImageConstant.appLogo,
              height: 30,
            ),
            const Spacer(),
            const AppImageAsset(image: ImageConstant.bellIcon),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterScreen()),
              ),
              child: const AppImageAsset(
                image: ImageConstant.filterIcon,
                height: 40,
                width: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setPrefValue() async {
    await setPrefBoolValue(isPDCompleted, true);
    Provider.of<UserProfileProvider>(context, listen: false)
        .getCurrentUserData(context);
  }
}
