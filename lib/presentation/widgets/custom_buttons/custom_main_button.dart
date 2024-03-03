import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/app_ui_constants.dart';

class CustomMainButton extends StatelessWidget {
  final void Function()? onTap;
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? iconPath;
  final double iconSize;
  final Color iconColor;

  const CustomMainButton({
    super.key,
    this.onTap,
    this.width = double.infinity,
    this.height = 52,
    this.borderRadius = AppUIConstants.commonBorderRadius,
    this.borderWidth = AppUIConstants.commonBorderWidth,
    this.borderColor = AppColors.buttonBorderColor,
    this.backgroundColor = AppColors.buttonBackgroundColor,
    this.foregroundColor = AppColors.buttonForegroundColor,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.iconPath,
    this.iconSize = 16,
    this.iconColor = AppColors.buttonForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 15;
    const double spaceBetweenIconAndText = 10;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          color: backgroundColor,
        ),
        child: iconPath == null
            ? Text(
                text,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: AppTypography.mainButtonStyle.copyWith(
                  color: foregroundColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: SvgPicture.asset(
                      ImageAssetPathFormater.formatImageAssetPath(
                        imageAssetPath: iconPath!,
                      ),
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: spaceBetweenIconAndText),
                  Text(
                    text,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTypography.mainButtonStyle.copyWith(
                      color: foregroundColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
