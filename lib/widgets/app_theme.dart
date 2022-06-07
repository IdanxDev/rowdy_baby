import 'package:dating/constant/color_constant.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme(_);

  //     ======================= Font Family =======================     //
  static const String defaultFont = 'Pangram';

  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: ColorConstant.themeScaffold,
    fontFamily: defaultFont,
    dividerColor: ColorConstant.transparent,
    elevatedButtonTheme: elevatedButtonThemeData,
    appBarTheme: appBarTheme,
    inputDecorationTheme: inputDecorationTheme,
  );

  static ElevatedButtonThemeData elevatedButtonThemeData =
      ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(ColorConstant.pink),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 26, vertical: 10)),
      elevation: MaterialStateProperty.all(0),
    ),
  );

  static AppBarTheme appBarTheme = const AppBarTheme(
    centerTitle: true,
    color: ColorConstant.darkBlue,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: defaultFont,
      fontSize: 18,
      color: ColorConstant.white,
      fontWeight: FontWeight.w500,
    ),
  );

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    hintStyle: const TextStyle(
      fontFamily: defaultFont,
      fontSize: 16,
      color: ColorConstant.lightPink,
      letterSpacing: 0.48,
    ),
    filled: true,
    fillColor: ColorConstant.darkPink,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    ),
  );
}
