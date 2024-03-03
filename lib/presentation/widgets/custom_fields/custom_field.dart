import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/app_ui_constants.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onTap;
  final String hintText;
  final bool obscureText;
  final bool autoCorrect;
  final bool enableSuggestions;
  final TextInputType? keyboardType;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final double height;
  final double buttonWidth;
  final Color buttonBackgroundColor;
  final String buttonIconPath;
  final Color buttonIconColor;
  final double buttonIconSize;

  const CustomSearchField({
    super.key,
    required this.controller,
    this.onTap,
    required this.hintText,
    this.obscureText = false,
    this.autoCorrect = false,
    this.enableSuggestions = false,
    this.keyboardType,
    this.borderWidth = AppUIConstants.commonBorderWidth,
    this.borderRadius = AppUIConstants.commonBorderRadius,
    this.borderColor = AppColors.fieldBorderColor,
    this.height = 44,
    this.buttonWidth = 44,
    this.buttonBackgroundColor = AppColors.buttonBackgroundColor,
    required this.buttonIconPath,
    this.buttonIconSize = 18,
    this.buttonIconColor = AppColors.buttonForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    const double fieldVerticalPadding = 10;
    const double fieldHorizontalPadding = 15;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
              ),
              border: Border(
                left: BorderSide(
                  color: borderColor,
                  width: borderWidth,
                ),
                top: BorderSide(
                  color: borderColor,
                  width: borderWidth,
                ),
                bottom: BorderSide(
                  color: borderColor,
                  width: borderWidth,
                ),
              ),
            ),
            child: TextField(
              onEditingComplete: onTap,
              obscureText: obscureText,
              controller: controller,
              enableSuggestions: enableSuggestions,
              keyboardType: keyboardType,
              // The field decoration.
              textAlign: TextAlign.left,
              cursorColor: AppColors.mainColor,
              style: AppTypography.secondTextStyle,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.secondTextStyle.copyWith(
                  color: AppColors.fieldHintTextColor,
                ),
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: fieldHorizontalPadding,
                  vertical: fieldVerticalPadding,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: buttonWidth,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
              color: buttonBackgroundColor,
            ),
            child: SizedBox(
              width: buttonIconSize,
              height: buttonIconSize,
              child: SvgPicture.asset(
                ImageAssetPathFormater.formatImageAssetPath(
                  imageAssetPath: buttonIconPath,
                ),
                colorFilter: ColorFilter.mode(
                  buttonIconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
