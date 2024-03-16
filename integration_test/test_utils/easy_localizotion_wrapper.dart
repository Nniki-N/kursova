import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kursova/core/app_localization.dart';

import 'json_asset_loader.dart';

Widget addEasyLocalizationWrapper({
  required Widget child,
}) {
  return EasyLocalization(
    path: AppLocalization.translationsPath,
    supportedLocales: AppLocalization.supportedLocales,
    assetLoader: const JsonAssetLoader(),
    child: child,
  );
}
