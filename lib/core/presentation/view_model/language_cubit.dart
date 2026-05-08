import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/services/language_service.dart';

// Language States
abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final Locale locale;
  final bool isRTL;

  const LanguageLoaded({required this.locale, required this.isRTL});

  @override
  List<Object> get props => [locale, isRTL];
}

class LanguageChanged extends LanguageState {
  final Locale locale;
  final bool isRTL;

  const LanguageChanged({required this.locale, required this.isRTL});

  @override
  List<Object> get props => [locale, isRTL];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError({required this.message});

  @override
  List<Object> get props => [message];
}

// Language Cubit
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
      // Fallback to English if there's an error
      emit(const LanguageLoaded(locale: Locale('en'), isRTL: false));
    }
  }

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    try {
      emit(LanguageLoading());
      await LanguageService.changeLanguage(context, languageCode);
      final locale = Locale(languageCode);
      emit(LanguageChanged(locale: locale, isRTL: languageCode == 'ar'));
      // Also emit LanguageLoaded to ensure consistency
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

  bool get isRTL =>
      state is LanguageLoaded ? (state as LanguageLoaded).isRTL : false;

  Locale get currentLocale => state is LanguageLoaded
      ? (state as LanguageLoaded).locale
      : const Locale('en');
}
