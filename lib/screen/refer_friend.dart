import 'package:dating/constant/color_constant.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ReferFriend extends StatefulWidget {
  const ReferFriend({Key? key}) : super(key: key);

  @override
  State<ReferFriend> createState() => ReferFriendState();
}

class ReferFriendState extends State<ReferFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RotatedBox(
              quarterTurns: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      color: ColorConstant.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 2,
                    alignment: Alignment.center,
                    decoration:
                        const BoxDecoration(color: ColorConstant.yellow),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      color: ColorConstant.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 2,
                    alignment: Alignment.center,
                    decoration:
                        const BoxDecoration(color: ColorConstant.yellow),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      color: ColorConstant.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            RotatedBox(
              quarterTurns: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const RotatedBox(
                    quarterTurns: -1,
                    child: AppText(
                      text: 'Send the referral link',
                      fontColor: ColorConstant.black,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 2,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: ColorConstant.transparent,
                    ),
                  ),
                  const RotatedBox(
                    quarterTurns: -1,
                    child: AppText(
                      text: 'Let your friend get sign up',
                      fontColor: ColorConstant.black,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 2,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: ColorConstant.transparent,
                    ),
                  ),
                  const RotatedBox(
                    quarterTurns: -1,
                    child: AppText(
                      text: 'Auto apply of your reward',
                      fontColor: ColorConstant.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
