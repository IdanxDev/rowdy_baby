import 'package:dating/constant/color_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key? key}) : super(key: key);

  @override
  State<JobScreen> createState() => JobScreenState();
}

class JobScreenState extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Your job',
              fontColor: ColorConstant.pink,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 34),
            TextFormField(
              controller: provider.jobNameController,
              style: const TextStyle(
                fontFamily: AppTheme.defaultFont,
                fontSize: 16,
                color: ColorConstant.black,
                letterSpacing: 0.48,
              ),
              decoration: const InputDecoration(
                hintText: 'ex: Software engineer',
                fillColor: ColorConstant.hintColor,
                hintStyle: TextStyle(
                  fontFamily: AppTheme.defaultFont,
                  fontSize: 20,
                  color: Color(0XFFBDBDBD),
                  letterSpacing: 0.48,
                ),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              onChanged: (String? jobName) {
                provider.userModel.occupation = jobName;
              },
            ),
          ],
        );
      },
    );
  }
}
