import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class JsonAssetLoader extends AssetLoader {
  const JsonAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) async {
    return {};
  }
}
