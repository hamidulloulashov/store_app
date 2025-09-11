import 'package:flutter/material.dart';
class ThemeViewModel extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;
  ThemeMode get currentTheme => _currentTheme;
  bool get isDark => _currentTheme == ThemeMode.dark;

  void toggleTheme() {
    _currentTheme =
        _currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}