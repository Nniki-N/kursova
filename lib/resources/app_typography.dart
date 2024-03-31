import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kursova/resources/app_colors.dart';

/// A class that contains all text styles used in UI.
abstract class AppTypography {
  static const double textHeight = 1.2;

  static TextStyle h1Style = const TextStyle(
    fontSize: kIsWeb ? 24 : 22,
    fontWeight: FontWeight.bold,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle h2Style = const TextStyle(
    fontSize: kIsWeb ? 22 : 20,
    fontWeight: FontWeight.bold,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle h3Style = const TextStyle(
    fontSize: kIsWeb ? 20 : 18,
    fontWeight: FontWeight.normal,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle mainTextStyle = const TextStyle(
    fontSize: kIsWeb ? 18 : 16,
    fontWeight: FontWeight.normal,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle secondTextStyle = const TextStyle(
    fontSize: kIsWeb ? 16 : 14,
    fontWeight: FontWeight.normal,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle subTextStyle = const TextStyle(
    fontSize: kIsWeb ? 13 : 11,
    fontWeight: FontWeight.normal,
    color: AppColors.mainTextColor,
    height: textHeight,
  );

  static TextStyle mainButtonStyle = const TextStyle(
    fontSize: kIsWeb ? 20 : 18,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonForegroundColor,
    height: textHeight,
  );
}
