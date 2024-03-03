// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:kursova/core/utils/widget_measure_util.dart';
import 'package:kursova/presentation/widgets/custom_popups/custom_positioned_help_popup.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_ui_constants.dart';

class CustomPositionedHelpPopUpWrapper extends StatelessWidget {
  final Widget child;
  final String helpTitle;
  final String helpText;
  final bool helpPointerTopRight;
  final bool helpPointerBottomLeft;
  final bool helpPointerBottomRight;
  final double fromChildLeftTopCornerMoveXDisctance;
  final double fromChildLeftTopCornerMoveYDisctance;

  CustomPositionedHelpPopUpWrapper({
    super.key,
    required this.child,
    required this.helpTitle,
    required this.helpText,
    this.helpPointerTopRight = false,
    this.helpPointerBottomLeft = false,
    this.helpPointerBottomRight = false,
    this.fromChildLeftTopCornerMoveXDisctance = 0,
    this.fromChildLeftTopCornerMoveYDisctance = 0,
  });

  final GlobalKey globalChildKey = GlobalKey();
  final GlobalKey globalPopUpKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const double popupHelpWidth = 460;
    const double popupHelpHeight = 400;

    const double padding = 20;
    const double closeIconSize = 18;

    final double contentHeight = MeasureUtil.measureWidget(
          SizedBox(
            width: popupHelpWidth - padding - padding - closeIconSize - 10,
            child: HelpPopUpContentColumn(
              helpTitle: helpTitle,
              helpText: helpText,
            ),
          ),
        ).height +
        padding * 2 +
        AppUIConstants.commonBorderWidth * 2;

    return GestureDetector(
      key: globalChildKey,
      onTap: () {
        final RenderBox childRenderbox =
            globalChildKey.currentContext!.findRenderObject() as RenderBox;
        final Offset position = childRenderbox.localToGlobal(Offset.zero);
        final double x = position.dx;
        final double y = position.dy;

        final double childWidth = childRenderbox.size.width;
        final double childHeight = childRenderbox.size.height;

        showDialog(
          context: context,
          barrierColor: AppColors.mainDarkColor.withOpacity(0.10),
          builder: (context) {
            return Stack(
              children: [
                Positioned(
                  left: !(helpPointerBottomRight || helpPointerTopRight)
                      ? x - fromChildLeftTopCornerMoveXDisctance
                      : x -
                          popupHelpWidth +
                          fromChildLeftTopCornerMoveXDisctance +
                          childWidth,
                  top: !(helpPointerBottomLeft || helpPointerBottomRight)
                      ? y + fromChildLeftTopCornerMoveYDisctance
                      : y -
                          (contentHeight < popupHelpHeight
                              ? contentHeight
                              : popupHelpHeight) -
                          fromChildLeftTopCornerMoveYDisctance +
                          childHeight,
                  child: CustomPositionedHelpPopUp(
                    key: globalPopUpKey,
                    helpTitle: helpTitle,
                    helpText: helpText,
                    width: popupHelpWidth,
                    height: contentHeight < popupHelpHeight
                        ? contentHeight
                        : popupHelpHeight,
                    padding: padding,
                    helpPointerTopRight: helpPointerTopRight,
                    helpPointerBottomLeft: helpPointerBottomLeft,
                    helpPointerBottomRight: helpPointerBottomRight,
                    closeIconSize: closeIconSize,
                  ),
                ),
              ],
            );
          },
        );
      },
      child: child,
    );
  }
}
