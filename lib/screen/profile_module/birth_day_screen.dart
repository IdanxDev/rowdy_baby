// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BirthDayScreen extends StatefulWidget {
  const BirthDayScreen({Key? key}) : super(key: key);

  @override
  State<BirthDayScreen> createState() => BirthDayScreenState();
}

class BirthDayScreenState extends State<BirthDayScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: AppText(
                text: 'When\'s your birthday ?',
                fontColor: ColorConstant.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: 'Day',
                          fontSize: 18,
                          wordSpacing: 0.54,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: () => selectDate(appProvider),
                          style: const TextStyle(
                            fontFamily: AppTheme.defaultFont,
                            fontSize: 16,
                            color: ColorConstant.white,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: 'Month',
                          fontSize: 18,
                          wordSpacing: 0.54,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: monthController,
                          readOnly: true,
                          onTap: () => selectDate(appProvider),
                          style: const TextStyle(
                            fontFamily: AppTheme.defaultFont,
                            fontSize: 16,
                            color: ColorConstant.white,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: 'Year',
                          fontSize: 18,
                          wordSpacing: 0.54,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: yearController,
                          readOnly: true,
                          onTap: () => selectDate(appProvider),
                          style: const TextStyle(
                            fontFamily: AppTheme.defaultFont,
                            fontSize: 16,
                            color: ColorConstant.white,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future selectDate(AppProvider appProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100, 1),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      helpText: 'Birth Date',
      confirmText: 'Okay',
      cancelText: 'Cancel',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: ColorConstant.pink,
            colorScheme: const ColorScheme.light(
              primary: ColorConstant.yellow,
              onSurface: ColorConstant.white,
            ),
            fontFamily: AppTheme.defaultFont,
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      appProvider.birthDate = picked;
      dateController.text = picked.day.toString();
      monthController.text = picked.month.toString();
      yearController.text = picked.year.toString();
      appProvider.userModel.age = picked.toIso8601String();
      appProvider.notifyListeners();
    }
  }
}
