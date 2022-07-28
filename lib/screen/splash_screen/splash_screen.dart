import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/screen/intro_screen/intro_screen.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool showIcon = false;

  @override
  initState() {
    Provider.of<LocalDataProvider>(context, listen: false).getCountries(context);
    Future.delayed(const Duration(seconds: 2), () => navigateToIntro());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 42),
        child: showIcon
            ? const AppImageAsset(image: ImageConstant.appLogo)
            : Lottie.asset('assets/animations/splash screen.json'),
      ),
    );
  }

  void navigateToIntro() {
    setState(() {
      showIcon = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
        (route) => false,
      );
    });
  }
}
