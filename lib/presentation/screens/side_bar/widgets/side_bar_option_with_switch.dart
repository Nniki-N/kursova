import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/presentation/widgets/custom_popups/custom_positioned_help_popup_wrapper.dart';
import 'package:kursova/presentation/widgets/custom_switches/custom_switch.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/graphics/resources.dart';

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
      children: [
        Expanded(
            child: Row(
          children: [
            Flexible(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: AppTypography.secondTextStyle,
              ),
            ),
            const SizedBox(width: 8),
            CustomPositionedHelpPopUpWrapper(
              helpPointerBottomLeft: true,
              fromChildLeftTopCornerMoveXDisctance: 24,
              fromChildLeftTopCornerMoveYDisctance: 35,
              helpTitle: infoTitle,
              helpText: infoText,
              child: SizedBox(
                width: infoIconSize,
                height: infoIconSize,
                child: SvgPicture.asset(
                  ImageAssetPathFormater.formatImageAssetPath(
                    imageAssetPath: Svgs.infoIcon,
                  ),
                ),
              ),
            ),
          ],
        )),
        const SizedBox(width: 15),
        CustomSwitch(
          value: value,
          onToggle: onToggle,
        ),
      ],
    );
  }
}
