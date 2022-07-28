import 'package:dating/constant/color_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCastScreen extends StatelessWidget {
  const SubCastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: AppText(
                text: 'What\'s your sub caste?',
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
                controller: provider.subCasteController,
                style: const TextStyle(
                  fontFamily: AppTheme.defaultFont,
                  fontSize: 16,
                  color: ColorConstant.white,
                  letterSpacing: 0.48,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter your sub caste',
                  fillColor: ColorConstant.darkPink,
                  hintStyle: TextStyle(
                    fontFamily: AppTheme.defaultFont,
                    fontSize: 20,
                    color: Color(0xFFFF7499),
                    letterSpacing: 0.48,
                  ),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                onChanged: (String? subCaste) {
                  provider.userModel.smoke = subCaste;
                },
              ),
            ),
            const SizedBox(height: 100),
            const Center(
              child: AppText(
                text: 'For Best Matching Result to Date then decide',
                fontSize: 16,
              ),
            ),
          ],
        );
      },
    );
  }
}
