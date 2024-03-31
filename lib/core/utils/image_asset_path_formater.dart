import 'package:flutter/foundation.dart';

/// An util that is used for local image assets path formating.
abstract class ImageAssetPathFormater {

  /// If the app is runned in web, first found 'assets/' path part will be removed from [imageAssetPath].
  static String formatImageAssetPath({
    required String imageAssetPath,
  }) {
    if (kIsWeb) {
      return imageAssetPath.replaceFirst('assets/', '');
    }

    return imageAssetPath;
  }
}
