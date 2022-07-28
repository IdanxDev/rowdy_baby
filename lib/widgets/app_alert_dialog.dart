import 'package:dating/constant/color_constant.dart';
import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final bool isAction;
  final bool isTextField;
  final bool isBlock;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;

  const CustomAlertDialog({
    Key? key,
    this.title = 'Message',
    this.message = 'No internet',
    this.isAction = false,
    this.isTextField = false,
    this.isBlock = false,
    this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  CustomAlertDialogState createState() => CustomAlertDialogState();
}

class CustomAlertDialogState extends State<CustomAlertDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: ColorConstant.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: ColorConstant.pink,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: ColorConstant.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  height: 100,
                  width: double.infinity,
                  child: widget.isTextField
                      ? TextFormField(
                          controller: widget.controller,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                        )
                      : Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ColorConstant.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                ),
                widget.isAction
                    ? Row(
                        children: [
                          const Spacer(),
                          AppElevatedButton(
                            text: 'Yes',
                            fontSize: 16,
                            width: 80,
                            borderRadius: 8,
                            buttonColor: ColorConstant.pink,
                            onPressed: widget.onTap,
                          ),
                          const Spacer(),
                          AppElevatedButton(
                            text: 'No',
                            fontSize: 16,
                            width: 80,
                            borderRadius: 8,
                            buttonColor: ColorConstant.pink,
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          widget.isBlock
                              ? Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false,
                                )
                              : Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: ColorConstant.pink,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Okay',
                            style: TextStyle(
                              color: ColorConstant.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                if (widget.isAction) const SizedBox(height: 8)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
