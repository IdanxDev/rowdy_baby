// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:dating/constant/color_constant.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmailPhoneBottomSheet extends StatefulWidget {
  final bool isPhone;

  const EmailPhoneBottomSheet({Key? key, this.isPhone = true})
      : super(key: key);

  @override
  State<EmailPhoneBottomSheet> createState() => EmailPhoneBottomSheetState();
}

class EmailPhoneBottomSheetState extends State<EmailPhoneBottomSheet> {
  UserService userService = UserService();
  final TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.transparent.withOpacity(0.5),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSheetBarrierView(context),
            buildSheetView(context),
          ],
        ),
      ),
    );
  }

  Container buildSheetView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 35, right: 25),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border.all(color: ColorConstant.grey),
        color: ColorConstant.white,
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          buildSheetAppBar(context),
          const SizedBox(height: 10),
          const AppText(
            text:
                'For subscription invoices and supports, Security please give your valid mobile number.',
            fontColor: ColorConstant.black,
            fontWeight: FontWeight.normal,
            fontSize: 16,
            maxLines: 4,
          ),
          const SizedBox(height: 34),
          TextFormField(
            controller: detailsController,
            style: const TextStyle(
              fontFamily: AppTheme.defaultFont,
              fontSize: 16,
              color: ColorConstant.black,
              letterSpacing: 0.48,
            ),
            decoration: InputDecoration(
              hintText: widget.isPhone
                  ? 'Enter mobile number'
                  : 'Enter email address',
              fillColor: ColorConstant.hintColor,
              hintStyle: const TextStyle(
                fontFamily: AppTheme.defaultFont,
                fontSize: 14,
                color: Color(0XFFBDBDBD),
                letterSpacing: 0.48,
              ),
            ),
            textInputAction: TextInputAction.done,
            keyboardType: widget.isPhone
                ? TextInputType.number
                : TextInputType.emailAddress,
            inputFormatters: [
              if (widget.isPhone) FilteringTextInputFormatter.digitsOnly,
              if (widget.isPhone) LengthLimitingTextInputFormatter(10),
            ],
          ),
          const SizedBox(height: 30),
          Consumer<UserProfileProvider>(
            builder: (context, provider, child) {
              return AppElevatedButton(
                text: 'Save',
                margin: 0,
                height: 50,
                fontSize: 16,
                onPressed: () => validateDetails(provider),
              );
            },
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }

  AppText buildSheetAppBar(BuildContext context) {
    return AppText(
      text: widget.isPhone ? 'Add phone number' : 'Add email Address',
      fontColor: ColorConstant.pink,
      fontWeight: FontWeight.bold,
      fontSize: 22,
      maxLines: 2,
    );
  }

  Expanded buildSheetBarrierView(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: ColorConstant.transparent,
          width: double.infinity,
        ),
      ),
    );
  }

  validateDetails(UserProfileProvider provider) async {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
    await userService.updateProfile(
      context,
      currentUserId: provider.currentUserId,
      key: widget.isPhone ? 'phoneNumber' : 'emailAddress',
      value: detailsController.text.trim(),
    );
    await provider.getCurrentUserData(context);
  }
}
