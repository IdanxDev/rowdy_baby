import 'package:dating/constant/color_constant.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/screen/person_details_module/person_details_screen.dart';
import 'package:dating/screen/profile_module/profile_screen.dart';
import 'package:dating/screen/splash_screen/splash_screen.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void urlLauncher({
  @required String? url,
  LaunchMode mode = LaunchMode.inAppWebView,
}) async {
  logs('urlLauncher --> $url');
  Uri uri = Uri.parse(url!);
  await canLaunchUrl(uri)
      ? await launchUrl(uri, mode: mode)
      : throw 'Could not launch --> $uri';
}

void logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}

showMessage(BuildContext context,
    {@required String? message,
    Color textColor = ColorConstant.themeScaffold,
    Color? backgroundColor = ColorConstant.pink,
    bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor:
          isError ? ColorConstant.red.withOpacity(0.9) : backgroundColor,
      content: Text(
        message!,
        style: TextStyle(
          fontFamily: AppTheme.defaultFont,
          color: textColor,
          fontWeight: FontWeight.w400,
          wordSpacing: 1,
          fontSize: 14,
        ),
      ),
    ),
  );
}

showInternetMessage() {
  Get.snackbar(
    'Oops, Something\'s not right',
    'message',
    snackPosition: SnackPosition.BOTTOM,
    isDismissible: false,
    backgroundColor: ColorConstant.pink,
    duration: const Duration(hours: 1),
    margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 66),
    titleText: const AppText(
      text: 'Oops, Something\'s not right',
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    messageText: Row(
      children: [
        const Expanded(
          child: AppText(
            text: 'Check your internet connection and tap "Retry" to try again',
            maxLines: 3,
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () async {
            bool isLogin = await getPrefBoolValue(isLoggedIn) ?? false;
            bool isProfileComplete = await getPrefBoolValue(isProfileCompleted) ?? false;
            bool isPDComplete = await getPrefBoolValue(isPDCompleted) ?? false;
            String? userData = await getPrefStringValue(savedProfileData);
            Get.offAll(() => isLogin
                ? isProfileComplete
                    ? isPDComplete
                        ? const HomeScreen()
                        : PersonDetailsScreen(userModel: userData)
                    : const ProfileScreen()
                : const SplashScreen());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: ColorConstant.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const AppText(text: 'Retry', fontColor: ColorConstant.pink),
          ),
        )
      ],
    ),
  );
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

String dateFormatter(String? date) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(DateTime.parse(date!));
  return formatted;
}

String expiryDate(String? date) {
  final DateFormat formatter = DateFormat('dd MMMM yyyy');
  final String formatted = formatter.format(DateTime.parse(date!));
  return formatted;
}
