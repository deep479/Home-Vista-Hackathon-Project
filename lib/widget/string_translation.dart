// ignore_for_file: avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> ar = {
    "Beauty parlour at your home": "صالون التجميل في منزلك",
    "Skip": "يتخطى"
  };
  static const Map<String, dynamic> en = {
    "hi_text": "Beauty parlour at your home",
    "this_should_be_translated": "This should be translated to Arabic!"
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ar": ar,
    "en": en
  };
}
