import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final bool isDarkMode;

  const ThemeChanged({required this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

class ThemeLoaded extends ThemeState {
  final bool isDarkMode;

  const ThemeLoaded({required this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial()) {
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    emit(ThemeLoaded(isDarkMode: event.isDarkMode));
    _saveThemePreference(event.isDarkMode);
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    try {
      final themeBox = await Hive.openBox('theme_box');
      await themeBox.put('is_dark_mode', isDarkMode);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  Future<bool> loadThemePreference() async {
    try {
      final themeBox = await Hive.openBox('theme_box');
      return themeBox.get('is_dark_mode') ?? false;
    } catch (e) {
      print('Error loading theme preference: $e');
      return false;
    }
  }
}
