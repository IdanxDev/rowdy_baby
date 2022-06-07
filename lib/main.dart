import 'package:dating/constant/string_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/person_details_module/person_details_screen.dart';
import 'package:dating/screen/profile_module/profile_screen.dart';
import 'package:dating/screen/splash_screen/splash_screen.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isLogin = await getPrefBoolValue(isLoggedIn) ?? false;
  bool isProfileComplete = await getPrefBoolValue(isProfileCompleted) ?? false;
  bool isPDComplete = await getPrefBoolValue(isPDCompleted) ?? false;
  int profileIndex = await getPrefIntValue(signInIndex) ?? 0;
  runApp(
    MyApp(
      isLogin: isLogin,
      isProfileComplete: isProfileComplete,
      isPDComplete: isPDComplete,
      profileIndex: profileIndex,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isLogin;
  final bool isProfileComplete;
  final bool isPDComplete;
  final int profileIndex;

  const MyApp({
    Key? key,
    this.isLogin = false,
    this.isProfileComplete = false,
    this.isPDComplete = false,
    this.profileIndex = 0,
  }) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<AppProvider>(create: (context) => AppProvider()),
    ChangeNotifierProvider<FilterProvider>(
        create: (context) => FilterProvider()),
    ChangeNotifierProvider<UserProfileProvider>(
        create: (context) => UserProfileProvider()),
    ChangeNotifierProvider<HomeProvider>(create: (context) => HomeProvider()),
  ];

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringConstant.appTitle,
        theme: AppTheme.themeData,
        // home: const HomeScreen(),
        home: widget.isLogin
            ? widget.isProfileComplete
                ? widget.isPDComplete
                    ? const HomeScreen()
                    : const PersonDetailsScreen()
                : const ProfileScreen()
            : const SplashScreen(),
      ),
    );
  }
}
