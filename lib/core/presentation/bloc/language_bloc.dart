import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final String locale;

  const LanguageChanged({required this.locale});

  @override
  List<Object> get props => [locale];
}

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial();
}

class LanguageLoaded extends LanguageState {
  final String locale;

  const LanguageLoaded({required this.locale});

  @override
  List<Object> get props => [locale];
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageInitial()) {
    on<LanguageChanged>(_onLanguageChanged);
  }

  void _onLanguageChanged(LanguageChanged event, Emitter<LanguageState> emit) {
    emit(LanguageLoaded(locale: event.locale));
  }

  Future<void> saveLanguagePreference(String locale) async {
    try {
      final languageBox = await Hive.openBox('language_box');
      await languageBox.put('current_language', locale);
      add(LanguageChanged(locale: locale));
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }

  Future<String> loadLanguagePreference() async {
    try {
      final languageBox = await Hive.openBox('language_box');
      return languageBox.get('current_language') ?? 'en';
    } catch (e) {
      print('Error loading language preference: $e');
      return 'en';
    }
  }
}
