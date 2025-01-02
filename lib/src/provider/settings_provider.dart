import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Fields for theme
  bool _isDarkMode = false;

  // Fields for server configuration
  String _serverAddress = '';
  String _serverPort = '8080';

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get serverAddress => _serverAddress;
  String get serverPort => _serverPort;

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    _isDarkMode = preferences.getBool('isDarkMode') ?? false;
    _serverAddress = preferences.getString('serverAddress') ?? '';
    _serverPort = preferences.getString('serverPort') ?? '8080';
    notifyListeners();
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Update language
  Future<void> updateServerAddress(String address) async {
    _serverAddress = address;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('serverAddress', _serverAddress);
    notifyListeners();
  }

  // Update language
  Future<void> updateServerPort(String port) async {
    _serverPort = port;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('serverAddress', _serverPort);
    notifyListeners();
  }  
}
