import 'package:flutter/material.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/app_ui_constants.dart';

/// A custom bottom sheet widget.
class CustomBottomSheet extends StatelessWidget {
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final double padding;
  final String title;
  final String text;

  const CustomBottomSheet({
    super.key,
    this.borderRadius = 20,
    this.borderWidth = AppUIConstants.commonBorderWidth,
    this.borderColor = AppColors.buttonBorderColor,
    this.backgroundColor = AppColors.popupBackgroundColor,
    this.padding = 30,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      padding: EdgeInsets.symmetric(horizontal: padding),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.h3Style.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              text,
              maxLines: 50,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.mainTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
