import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_ui_constants.dart';

class CustomSquareButtonWithIcon extends StatefulWidget {
  final void Function()? onTap;
  final double size;
  final Color backgroundColor;
  final Color backgroundHoveredOrPressedColor;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final double iconSize;
  final Color iconColor;
  final String iconPath;
  final bool detectWhenButtonIsHoveredOrPressed;

  const CustomSquareButtonWithIcon({
    super.key,
    this.onTap,
    this.size = 44,
    this.borderWidth = AppUIConstants.commonBorderWidth,
    this.borderRadius = AppUIConstants.commonBorderRadius,
    this.borderColor = AppColors.buttonBorderColor,
    this.backgroundColor = AppColors.buttonBackgroundColor,
    this.backgroundHoveredOrPressedColor =
        AppColors.hoveredSmallButtonBackgroundColor,
    this.iconColor = AppColors.buttonForegroundColor,
    this.iconSize = 14,
    required this.iconPath,
    this.detectWhenButtonIsHoveredOrPressed = false,
  });

  @override
  State<CustomSquareButtonWithIcon> createState() =>
      _CustomSquareButtonWithIconState();
}

class _CustomSquareButtonWithIconState
    extends State<CustomSquareButtonWithIcon> {
  bool buttonWasHoveredOrPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: !widget.detectWhenButtonIsHoveredOrPressed
          ? null
          : (event) {
              setState(() {
                buttonWasHoveredOrPressed = true;
              });
            },
      onExit: !widget.detectWhenButtonIsHoveredOrPressed
          ? null
          : (event) {
              setState(() {
                buttonWasHoveredOrPressed = false;
              });
            },
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: !widget.detectWhenButtonIsHoveredOrPressed
            ? null
            : (tapDetaild) {
                setState(() {
                  buttonWasHoveredOrPressed = true;
                });
              },
        onTapUp: !widget.detectWhenButtonIsHoveredOrPressed
            ? null
            : (tapDetaild) {
                setState(() {
                  buttonWasHoveredOrPressed = false;
                });
              },
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
            color: buttonWasHoveredOrPressed
                ? widget.backgroundHoveredOrPressedColor
                : widget.backgroundColor,
          ),
          child: SizedBox(
            width: widget.iconSize,
            height: widget.iconSize,
            child: SvgPicture.asset(
              ImageAssetPathFormater.formatImageAssetPath(
                imageAssetPath: widget.iconPath,
              ),
              colorFilter: ColorFilter.mode(
                widget.iconColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
