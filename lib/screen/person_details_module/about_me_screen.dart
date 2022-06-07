// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dating/constant/color_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({Key? key}) : super(key: key);

  @override
  State<AboutMeScreen> createState() => AboutMeScreenState();
}

class AboutMeScreenState extends State<AboutMeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'About me',
              fontColor: ColorConstant.pink,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 34),
            TextFormField(
              controller: appProvider.aboutMeController,
              onChanged: (String? aboutMe) {
                appProvider.aboutCharacter =
                    appProvider.maxCharacter - aboutMe!.length;
                appProvider.userModel.aboutMe = aboutMe;
                appProvider.notifyListeners();
              },
              style: const TextStyle(
                fontFamily: AppTheme.defaultFont,
                fontSize: 16,
                color: ColorConstant.black,
                letterSpacing: 0.48,
              ),
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Type here',
                fillColor: ColorConstant.hintColor,
                hintStyle: TextStyle(
                  fontFamily: AppTheme.defaultFont,
                  fontSize: 20,
                  color: Color(0XFFBDBDBD),
                  letterSpacing: 0.48,
                ),
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(300)],
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  text: 'Max ',
                  style: const TextStyle(
                    fontFamily: AppTheme.defaultFont,
                    color: Color(0XFF939393),
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${appProvider.aboutCharacter}',
                      style: const TextStyle(color: ColorConstant.pink),
                    ),
                    const TextSpan(text: ' characters'),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
