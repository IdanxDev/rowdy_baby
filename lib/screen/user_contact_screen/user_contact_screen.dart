import 'package:dating/constant/color_constant.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:dating/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserContactScreen extends StatefulWidget {
  final String? contactDetails;
  final bool isPhone;

  const UserContactScreen({
    Key? key,
    @required this.contactDetails,
    this.isPhone = false,
  }) : super(key: key);

  @override
  State<UserContactScreen> createState() => UserContactScreenState();
}

class UserContactScreenState extends State<UserContactScreen> {
  final TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    detailsController.text = widget.contactDetails!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          primary: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 42, right: 32, left: 32),
          children: [
            AppText(
              text: widget.isPhone ? 'Phone number' : 'Email Address',
              fontColor: ColorConstant.pink,
              fontSize: 40,
              fontWeight: FontWeight.bold,
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
                hintText: widget.isPhone ? 'Phone number' : 'Email Address',
                fillColor: ColorConstant.hintColor,
                hintStyle: const TextStyle(
                  fontFamily: AppTheme.defaultFont,
                  fontSize: 20,
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, detailsController.text);
          },
          backgroundColor: ColorConstant.pink,
          child: const Icon(Icons.done, color: ColorConstant.white),
        ),
      ),
    );
  }
}
