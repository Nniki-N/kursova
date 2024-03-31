import 'package:flutter/material.dart';

/// A class that represents available app localizations.
class AppLocalization {
  static const String translationsPath = 'assets/translations';
  static const Locale enLocale = Locale('en', 'GB');
  static const Locale ukLocale = Locale('uk', 'UA');

  static List<Locale> supportedLocales = [enLocale, ukLocale];
}
