import 'package:flutter/material.dart';
import 'package:kursova/presentation/widgets/custom_buttons/info_button.dart';
import 'package:kursova/presentation/widgets/custom_switches/custom_switch.dart';
import 'package:kursova/resources/app_typography.dart';

class SideBarOptionWithSwitch extends StatelessWidget {
  final String text;
  final String infoTitle;
  final String infoText;
  final bool? value;
  final void Function(bool)? onToggle;

  const SideBarOptionWithSwitch({
    super.key,
    required this.text,
    required this.infoTitle,
    required this.infoText,
    this.value,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    const double infoIconSize = 16;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: text,
                  style: AppTypography.secondTextStyle,
                ),
                const WidgetSpan(
                  child: SizedBox(width: 8),
                ),
                WidgetSpan(
                  child: InfoButton(
                    infoIconSize: infoIconSize,
                    infoTitle: infoTitle,
                    infoText: infoText,
                    fromChildLeftTopCornerMoveXDisctance: 24,
                    fromChildLeftTopCornerMoveYDisctance: 35,
                    pointerBottomLeft: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 30),
        CustomSwitch(
          value: value,
          onToggle: onToggle,
        ),
      ],
    );
  }
}
