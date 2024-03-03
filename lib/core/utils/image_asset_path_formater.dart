import 'package:flutter/foundation.dart';

abstract class ImageAssetPathFormater {
  static String formatImageAssetPath({required String imageAssetPath}) {
    if (kIsWeb) {
      return imageAssetPath.replaceFirst('assets/', '');
    }

    return imageAssetPath;
  }
}
