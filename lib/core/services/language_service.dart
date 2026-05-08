import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageService {
  static const String _languageBoxName = 'language_box';
  static const String _languageKey = 'selected_language';
  static const String _defaultLanguage = 'en';

  static Future<void> init() async {
    await Hive.openBox(_languageBoxName);
  }

  static Future<void> saveLanguage(String languageCode) async {
    final box = Hive.box(_languageBoxName);
    await box.put(_languageKey, languageCode);
  }

  static String getSavedLanguage() {
    try {
      final box = Hive.box(_languageBoxName);
      return box.get(_languageKey, defaultValue: _defaultLanguage);
    } catch (e) {
      return _defaultLanguage;
    }
  }

  static Future<void> changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    await saveLanguage(languageCode);
    await EasyLocalization.of(context)?.setLocale(Locale(languageCode));
  }

  static Locale getCurrentLocale() {
    final savedLanguage = getSavedLanguage();
    return Locale(savedLanguage);
  }

  static bool isRTL() {
    final currentLanguage = getSavedLanguage();
    return currentLanguage == 'ar';
  }

  static List<Locale> get supportedLocales => [
    const Locale('en'),
    const Locale('ar'),
  ];

  static Future<void> clearLanguage() async {
    final box = Hive.box(_languageBoxName);
    await box.delete(_languageKey);
  }
}
