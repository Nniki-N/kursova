// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:kursova/core/utils/widget_measure_util.dart';
import 'package:kursova/presentation/widgets/custom_popups/custom_positioned_popup.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_ui_constants.dart';

/// A wrapper for a [child] that by clicking on it shows a custom positioned popup.
/// 
/// The positioned popup has a mandatory pointer that is attached to bottom or top of the popup. By default the pointer is on top left side.
/// 
/// Postion of the pointer can be changed by setting [pointerTopRight] or [pointerBottomLeft] or [pointerBottomRight] to true.
/// By selecting several sides for pointer, right side will have higher priority than left side and bottom side will have higher priority than top side.
/// 
/// [fromChildLeftTopCornerMoveXDisctance] and [fromChildLeftTopCornerMoveYDisctance] define shift of the popup from left top corner of the [child].
class CustomPositionedInfoPopUpWrapper extends StatelessWidget {
  final Widget child;
  final String infoTitle;
  final String infoText;
  final bool pointerTopRight;
  final bool pointerBottomLeft;
  final bool pointerBottomRight;
  final double fromChildLeftTopCornerMoveXDisctance;
  final double fromChildLeftTopCornerMoveYDisctance;

  CustomPositionedInfoPopUpWrapper({
    super.key,
    required this.child,
    required this.infoTitle,
    required this.infoText,
    this.pointerTopRight = false,
    this.pointerBottomLeft = false,
    this.pointerBottomRight = false,
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

    final double contentHeight = WidgetMeasureUtil.measureWidget(
          SizedBox(
            width: popupHelpWidth - padding - padding - closeIconSize - 10,
            child: CustomPositionedPopUpContentColumn(
              title: infoTitle,
              text: infoText,
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
                  left: !(pointerBottomRight || pointerTopRight)
                      ? x - fromChildLeftTopCornerMoveXDisctance
                      : x -
                          popupHelpWidth +
                          fromChildLeftTopCornerMoveXDisctance +
                          childWidth,
                  top: !(pointerBottomLeft || pointerBottomRight)
                      ? y + fromChildLeftTopCornerMoveYDisctance
                      : y -
                          (contentHeight < popupHelpHeight
                              ? contentHeight
                              : popupHelpHeight) -
                          fromChildLeftTopCornerMoveYDisctance +
                          childHeight,
                  child: CustomPositionedPopUp(
                    key: globalPopUpKey,
                    title: infoTitle,
                    text: infoText,
                    width: popupHelpWidth,
                    height: contentHeight < popupHelpHeight
                        ? contentHeight
                        : popupHelpHeight,
                    padding: padding,
                    pointerTopRight: pointerTopRight,
                    pointerBottomLeft: pointerBottomLeft,
                    pointerBottomRight: pointerBottomRight,
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
