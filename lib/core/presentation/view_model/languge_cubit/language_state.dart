import 'dart:ui';

import 'package:equatable/equatable.dart';

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