import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/presentation/widgets/custom_bottom_sheet/custom_info_bottom_sheet_wrapper.dart';
import 'package:kursova/presentation/widgets/custom_popups/custom_positioned_info_popup_wrapper.dart';
import 'package:kursova/resources/app_ui_constants.dart';
import 'package:kursova/resources/graphics/resources.dart';


/// The info button shows a positioned popup or a bottom sheet with hint text.
/// 
/// The positioned popup is shown if screen is larger than of a small tablet, otherwise the bottoms sheet is shown.
/// 
/// The positioned popup has a mandatory pointer that is attached to bottom or top of the popup. By default pointer is on the top left side.
/// 
/// Postion of the pointer can be changed by setting [pointerTopRight] or [pointerBottomLeft] or [pointerBottomRight] to true.
/// By selecting several sides for pointer, right side will have higher priority than left side and bottom side will have higher priority than top side.
/// 
/// [fromChildLeftTopCornerMoveXDisctance] and [fromChildLeftTopCornerMoveYDisctance] define shift of the popup from left top corner of the button.
class InfoButton extends StatelessWidget {
  final String infoTitle;
  final String infoText;
  final double infoIconSize;
  final double fromChildLeftTopCornerMoveXDisctance;
  final double fromChildLeftTopCornerMoveYDisctance;
  final bool pointerTopRight;
  final bool pointerBottomLeft;
  final bool pointerBottomRight;
  final bool showOnlyPositionedPopUp;
  final bool showOnlyBottomSheet;

  const InfoButton({
    super.key,
    required this.infoTitle,
    required this.infoText,
    required this.infoIconSize,
    required this.fromChildLeftTopCornerMoveXDisctance,
    required this.fromChildLeftTopCornerMoveYDisctance,
    this.pointerTopRight = false,
    this.pointerBottomLeft = false,
    this.pointerBottomRight = false,
    this.showOnlyPositionedPopUp = false,
    this.showOnlyBottomSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showOnlyBottomSheet) {
      return _bottomSheet();
    }

    if (showOnlyPositionedPopUp) {
      return _positionedPopUp();
    }

    final Size screenSize = MediaQuery.of(context).size;
    final bool showBottomSheet =
        screenSize.width < AppUIConstants.maximalWidthToShowBottomSheet ||
            screenSize.height < AppUIConstants.maximalHeightToShowBottomSheet;

    // Shows bottom sheet when screen is too small
    if (showBottomSheet) {
      return _bottomSheet();
    }

    return _positionedPopUp();
  }

  Widget _positionedPopUp() {
    return CustomPositionedInfoPopUpWrapper(
      pointerBottomLeft: pointerBottomLeft,
      pointerBottomRight: pointerBottomRight,
      pointerTopRight: pointerTopRight,
      fromChildLeftTopCornerMoveXDisctance:
          fromChildLeftTopCornerMoveXDisctance,
      fromChildLeftTopCornerMoveYDisctance:
          fromChildLeftTopCornerMoveYDisctance,
      infoTitle: infoTitle,
      infoText: infoText,
      child: SizedBox(
        width: infoIconSize,
        height: infoIconSize,
        child: SvgPicture.asset(
          ImageAssetPathFormater.formatImageAssetPath(
            imageAssetPath: Svgs.infoIcon,
          ),
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return CustomInfoBottomSheetWrapper(
      infoTitle: infoTitle,
      infoText: infoText,
      child: SvgPicture.asset(
        ImageAssetPathFormater.formatImageAssetPath(
          imageAssetPath: Svgs.infoIcon,
        ),
      ),
    );
  }
}
