import 'package:flutter/material.dart';

/// A class that contains all colors used in UI.
abstract class AppColors {
  // Common
  static const Color whitenColor = Color(0xFFFFFFFF);
  static const Color mainColor = Color(0xFF3CEE99);
  static const Color mainDarkColor = Color(0xFF17211C);
  static const Color backgroundColor = whitenColor;

  // Text
  static const Color mainTextColor = Color(0xFF000000);
  static const Color secondTextColor = mainDarkColor;
  static const Color darkGrayTextColor = Color(0xFF6B6B6B);
  static const Color lightGrayTextColor = Color(0xFFAFAFAF);

  // Button
  static const Color buttonForegroundColor = mainDarkColor;
  static const Color buttonBackgroundColor = mainColor;
  static const Color buttonBorderColor = mainDarkColor;

  static const Color denyButtonForegroundColor = Color(0xFF5E0C0C);
  static const Color denyButtonBackgroundColor = Color(0xFFEE3C3C);
  static const Color denyButtonBorderColor = Color(0xFF5E0C0C);
  static const Color unhoveredSmallButtonForegroundColor = Color(0xFFFFFFFF);
  static const Color unhoveredSmallButtonBackgroundColor = Color(0xFFECECEC);
  static const Color hoveredSmallButtonBackgroundColor = Color(0xFFD64E4E);

  // Switch
  static const Color switchBorderColor = mainDarkColor;
  static const Color switchBackgroundColor = Colors.transparent;
  static const Color switchInactiveToggleColor = Color(0xFFECECEC);
  static const Color switchActiveToggleColor = mainColor;

  // Field
  static const Color fieldBorderColor = mainDarkColor;
  static const Color fieldHintTextColor = Color(0xFF6B6B6B);

  // Snackbar
  static const Color snackbarErrorBackgroundColor = Color(0xFFE24B4B);
  static const Color snackbarErrorForegroundColor = Color(0xFF5E0C0C);
  static const Color snackbarErrorBorderColor = Color(0xFF791515);
  static const Color snackbarShadowColor = Color(0xFFE04444);

  // Popup
  static const Color popupBackgroundColor = backgroundColor;
  static const Color popupBorderColor = mainDarkColor;
  static const Color popupOverlayColor = mainDarkColor;

  // Decoration
  static const Color locationSeparationColor = Color(0xFFC2C2C2);

  // Shadow
  static const Color mainShadowColor = mainDarkColor;

  // Map
  static const Color routeColor = mainColor;
}
