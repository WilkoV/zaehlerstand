import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> loadTheme() async {
    final preferences = await SharedPreferences.getInstance();
    _isDarkMode = preferences.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
