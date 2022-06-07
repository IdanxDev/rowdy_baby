import 'dart:math' as math;

import 'package:dating/widgets/app_swipe_card/card_colors.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';

const labelAngle = math.pi / 2 * 0.2;

class CardLabel extends StatelessWidget {
  final Color? fontColor;
  final String? actionName;
  final double? actionAngle;
  final Alignment? alignment;

  const CardLabel._({
    @required this.fontColor,
    @required this.actionName,
    @required this.actionAngle,
    @required this.alignment,
  });

  factory CardLabel.right() {
    return const CardLabel._(
      fontColor: SwipeDirectionColor.right,
      actionName: 'Like',
      actionAngle: -labelAngle,
      alignment: Alignment.topLeft,
    );
  }

  factory CardLabel.left() {
    return const CardLabel._(
      fontColor: SwipeDirectionColor.left,
      actionName: 'Pass',
      actionAngle: labelAngle,
      alignment: Alignment.topRight,
    );
  }

  factory CardLabel.up() {
    return const CardLabel._(
      fontColor: SwipeDirectionColor.up,
      actionName: 'UP',
      actionAngle: labelAngle,
      alignment: Alignment(0, 0.5),
    );
  }

  factory CardLabel.down() {
    return const CardLabel._(
      fontColor: SwipeDirectionColor.down,
      actionName: 'DOWN',
      actionAngle: -labelAngle,
      alignment: Alignment(0, -0.75),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(
        vertical: 36,
        horizontal: 36,
      ),
      child: Transform.rotate(
        angle: actionAngle!,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: fontColor!,
              width: 4,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(6),
          child: AppText(
            text: actionName!,
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
            fontColor: fontColor!,
          ),
        ),
      ),
    );
  }
}
