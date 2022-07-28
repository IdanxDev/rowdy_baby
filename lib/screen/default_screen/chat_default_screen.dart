import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/screen/premium_screen/payment_screen.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ChatDefaultScreen extends StatefulWidget {
  final bool isLoader;

  const ChatDefaultScreen({Key? key, this.isLoader = false}) : super(key: key);

  @override
  State<ChatDefaultScreen> createState() => ChatDefaultScreenState();
}

class ChatDefaultScreenState extends State<ChatDefaultScreen> {
  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            primary: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: AppImageAsset(
                  image: ImageConstant.chatDefault,
                  height: 190,
                ),
              ),
              const SizedBox(height: 30),
              const AppText(
                text: 'Find your Matches & Conversations',
                textAlign: TextAlign.center,
                fontColor: ColorConstant.pink,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  text: widget.isLoader
                      ? 'We are fetching your favourites . . .'
                      : 'Subscribe to the premium and chat directly with anyone and see your all matches here',
                  textAlign: TextAlign.center,
                  fontColor: ColorConstant.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 40),
              if (!widget.isLoader)
                AppElevatedButton(
                  text: 'Upgrade to Premium',
                  height: 50,
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  borderRadius: 10,
                  fontSize: 14,
                  margin: 60,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScreen(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
