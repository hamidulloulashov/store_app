import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// Event
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

// State
class ThemeState {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  bool get isDark => themeMode == ThemeMode.dark;
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.light)) {
    on<ToggleThemeEvent>((event, emit) {
      final newTheme = state.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      emit(state.copyWith(themeMode: newTheme));
    });
  }
}
