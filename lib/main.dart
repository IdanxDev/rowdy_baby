import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dating/constant/string_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/provider/premium_screen/premium_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/person_details_module/person_details_screen.dart';
import 'package:dating/screen/profile_module/profile_screen.dart';
import 'package:dating/screen/splash_screen/splash_screen.dart';
import 'package:dating/service/notification_service.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isLogin = await getPrefBoolValue(isLoggedIn) ?? false;
  bool isProfileComplete = await getPrefBoolValue(isProfileCompleted) ?? false;
  bool isPDComplete = await getPrefBoolValue(isPDCompleted) ?? false;
  String? userData = await getPrefStringValue(savedProfileData);
  runApp(
    MyApp(
      isLogin: isLogin,
      isProfileComplete: isProfileComplete,
      isPDComplete: isPDComplete,
      userData: userData,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isLogin;
  final bool isProfileComplete;
  final bool isPDComplete;
  final String? userData;

  const MyApp({
    Key? key,
    this.isLogin = false,
    this.isProfileComplete = false,
    this.isPDComplete = false,
    this.userData,
  }) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  Connectivity connectivity = Connectivity();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<AppProvider>(create: (context) => AppProvider()),
    ChangeNotifierProvider<FilterProvider>(create: (context) => FilterProvider()),
    ChangeNotifierProvider<UserProfileProvider>(create: (context) => UserProfileProvider()),
    ChangeNotifierProvider<HomeProvider>(create: (context) => HomeProvider()),
    ChangeNotifierProvider<SubscriptionProvider>(create: (context) => SubscriptionProvider()),
    ChangeNotifierProvider<LocalDataProvider>(create: (context) => LocalDataProvider()),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivitySubscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none ||
          connectivityResult == ConnectivityResult.bluetooth) {
        showInternetMessage();
      } else {
        Get.closeAllSnackbars();
        Get.offAll(() => widget.isLogin
            ? widget.isProfileComplete
                ? widget.isPDComplete
                    ? const HomeScreen()
                    : PersonDetailsScreen(userModel: widget.userData)
                : const ProfileScreen()
            : const SplashScreen());
      }
    });
    NotificationService.initializeNotification(context);
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        showInternetMessage();
      }
    });
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return MultiProvider(
      providers: providers,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringConstant.appTitle,
        theme: AppTheme.themeData,
        // navigatorKey: navigatorKey,
        home: const SplashScreen(),
        // home: widget.isLogin
        //     ? widget.isProfileComplete
        //         ? widget.isPDComplete
        //             ? const HomeScreen()
        //             : PersonDetailsScreen(userModel: widget.userData)
        //         : const ProfileScreen()
        //     : const SplashScreen(),
      ),
    );
  }

  void initNotification() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@drawable/app_icon');
    IOSInitializationSettings iosInitializationSettings =
        const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    InitializationSettings platform = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(platform);
  }
}
