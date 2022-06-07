import 'package:dating/constant/color_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  State<NameScreen> createState() => NameScreenState();
}

class NameScreenState extends State<NameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: AppText(
                text: 'Name',
                fontColor: ColorConstant.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: provider.nameController,
                style: const TextStyle(
                  fontFamily: AppTheme.defaultFont,
                  fontSize: 16,
                  color: ColorConstant.white,
                  letterSpacing: 0.48,
                ),
                decoration: const InputDecoration(hintText: 'Your full name'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                onChanged: (String? userName) {
                  provider.userModel.userName = userName;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
