import 'package:flutter/material.dart';
import 'package:kursova/resources/app_colors.dart';

abstract class AppTypography {
  static const double textHeight = 1.2;

  static TextStyle h1Style = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle h2Style = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle h3Style = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle mainTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle secondTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle subTextStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle mainButtonStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonForegroundColor,
    height: textHeight,
  );
}
