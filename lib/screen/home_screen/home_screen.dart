// ignore_for_file: use_build_context_synchronously, deprecated_member_use, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/model/bottom_nav_bar_model.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/chat_module/chat_screen.dart';
import 'package:dating/screen/filter_module/filter_screen.dart';
import 'package:dating/screen/home_module/profile_screen/profile_screen.dart';
import 'package:dating/screen/home_module/swipe_screen/swipe_screen.dart';
import 'package:dating/screen/like_reject_screen/liked_by_other_screen/liked_by_other_screen.dart';
import 'package:dating/service/location_service.dart';
import 'package:dating/service/notification_service.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_bottom_bar/app_bottom_bar.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;

  const HomeScreen({Key? key, this.selectedIndex = 1}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserService userService = UserService();
  NotificationService notificationService = NotificationService();
  LocationService locationService = LocationService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<Widget> homeScreenList = [
    const MyProfileScreen(),
    const SwipeScreen(),
    const LikedByOtherScreen(),
    const ChatScreen(),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logs('Current state --> ${state.name}');
    if (state == AppLifecycleState.resumed) {
      getCurrentUserStatus();
    } else {
      getCurrentUserStatus(isOnline: false);
    }
  }

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
      tabName: 'Matches',
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
    WidgetsBinding.instance.addObserver(this);
    Provider.of<LocalDataProvider>(context, listen: false).getCountries(context);
    setDailyNotification();
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
                  appBar: buildAppBar(context, appProvider),
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
        selectedIndex: appProvider.bottomNavBarIndex,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        duration: const Duration(milliseconds: 800),
        onTabChange: (int selectedIndex) {
          if (selectedIndex == 1) {
            homeProvider.getAllUsers(context, isSwipe: true);
            homeProvider.notifyListeners();
          }
          appProvider.changeBottomNavBar(selectedIndex);
          homeProvider.isDetails = false;
          homeProvider.isCardCompleted = false;
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

  PreferredSize buildAppBar(BuildContext context, AppProvider appProvider) {
    return PreferredSize(
      preferredSize: appProvider.bottomNavBarIndex == 1
          ? Size.fromHeight(AppBar().preferredSize.height * 2)
          : const Size(0, 0),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const AppImageAsset(
              image: ImageConstant.appLogo,
              height: 30,
            ),
            const Spacer(),
            // const AppImageAsset(image: ImageConstant.bellIcon),
            // const SizedBox(width: 20),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterScreen(),
                ),
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

  Future<void> setDailyNotification() async {
    await setPrefBoolValue(isPDCompleted, true);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.bottomNavBarIndex = widget.selectedIndex;
    appProvider.notifyListeners();
    final userProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    await userProvider.getCurrentUserData(context);
    flutterLocalNotificationsPlugin.cancelAll();
    await NotificationService.initializeNotification(context);
    await sendDailyNotification(userProvider);
    await getCurrentUserStatus();
    String? fcmToken = await NotificationService.generateFCMToken(context);
    await userService.updateProfile(
      context,
      currentUserId: userProvider.currentUserId,
      key: 'fcmToken',
      value: fcmToken,
      showError: false,
    );
    bool isGranted = await locationService.checkLocationPermission(context);
    if (!isGranted) await getCurrentLocation(userProvider.currentUserId);
  }

  Future<void> sendDailyNotification(UserProfileProvider userProvider) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'CHANNEL ID',
      'CHANNEL NAME',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      playSound: true,
    );
    IOSNotificationDetails iosNotificationDetails =
        const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails platformNotification = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    setDateArray(userProvider, platformNotification);
  }

  Future<void> setDateArray(UserProfileProvider userProvider,
      NotificationDetails platformNotification) async {
    DateTime dateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().hour >= 7 ? DateTime.now().day + 1 : DateTime.now().day,
        7);
    for (int i = 0; i < 10; i++) {
      DateTime newDateTime = dateTime.add(Duration(days: i));
      await flutterLocalNotificationsPlugin.schedule(
        i,
        'Hello, Rowdy ${userProvider.currentUserData!.userName}',
        'Your rowdy baby waiting for you',
        newDateTime,
        platformNotification,
      );
    }
  }

  Future<void> getCurrentUserStatus({bool isOnline = true}) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    logs('User id --> $userId');
    await userService.updateProfile(
      context,
      currentUserId: userId,
      key: 'userStatus',
      value: isOnline,
    );
    // if (!isOnline) {
    await userService.updateProfile(
      context,
      currentUserId: userId,
      key: 'lastOnline',
      value: DateTime.now().toIso8601String(),
    );
    // }
  }

  Future<void> getCurrentLocation(String? currentUserId) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const AppImageAsset(
          image: 'assets/images/location.svg',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const AppText(
              text: 'Turn on device location',
              fontColor: ColorConstant.pink,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            const AppText(
              text: 'We need your device location to show distances of each other',
              fontColor: ColorConstant.black,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xffEAE7E7),
                    ),
                    child: const AppText(
                      text: 'Cancel',
                      fontColor: ColorConstant.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    bool isServiceEnable = await locationService.checkLocationService(context);
                    if (isServiceEnable) {
                      bool isGranted = await locationService.checkLocationPermission(context);
                      logs('message --> $isGranted');
                      if (isGranted) {
                        updatePosition(currentUserId);
                      } else {
                        await locationService.checkLocationPermission(context);
                        await GeolocatorPlatform.instance.requestPermission();
                        updatePosition(currentUserId);
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: ColorConstant.pink,
                    ),
                    child: const AppText(
                      text: 'Enable location',
                      fontColor: ColorConstant.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updatePosition(String? currentUserId) async {
    Position? position = locationService.position;
    if (position != null) {
      logs('User id --> $currentUserId');
      await userService.updateProfile(
        context,
        currentUserId: currentUserId,
        key: 'location',
        value: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );
    }
  }
}
