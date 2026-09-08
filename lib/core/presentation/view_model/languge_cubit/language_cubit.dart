import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:p/core/presentation/view_model/languge_cubit/language_state.dart';
import 'package:p/core/services/language_service.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial()) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final savedLanguage = LanguageService.getSavedLanguage();
      final locale = Locale(savedLanguage);
      emit(LanguageLoaded(locale: locale, isRTL: savedLanguage == 'ar'));
    } catch (e) {
      emit(const LanguageLoaded(locale: Locale('en'), isRTL: false));
    }
  }

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    try {
      emit(LanguageLoading());
      await LanguageService.changeLanguage(context, languageCode);
      final locale = Locale(languageCode);
      emit(LanguageChanged(locale: locale, isRTL: languageCode == 'ar'));
      emit(LanguageLoaded(locale: locale, isRTL: languageCode == 'ar'));
    } catch (e) {
      emit(
        LanguageError(message: 'Failed to change language: ${e.toString()}'),
      );
    }
  }

  Future<void> toggleLanguage(BuildContext context) async {
    final currentLanguage = state is LanguageLoaded
        ? (state as LanguageLoaded).locale.languageCode
        : 'en';
    final newLanguage = currentLanguage == 'en' ? 'ar' : 'en';
    await changeLanguage(context, newLanguage);
  }
}
