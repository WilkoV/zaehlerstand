import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Fields for theme
  bool _isDarkMode = false;

  // Fields for server configuration
  String _serverAddress = '';
  String _serverPort = '8080';

  // Fields for additional settings
  bool _showReading = false;
  bool _consumption = true;
  bool _showTemperature = true;
  bool _showFeelsLike = false;
  String _daddysSelectedView = 'Jahr';
  String _daddysAggregation = 'Tag';

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get serverAddress => _serverAddress;
  String get serverPort => _serverPort;
  bool get showReading => _showReading;
  bool get showConsumption => _consumption;
  bool get showTemperature => _showTemperature;
  bool get showFeelsLike => _showFeelsLike;
  String get daddysSelectedView => _daddysSelectedView;
  String get daddysAggregation => _daddysAggregation;

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final preferences = await SharedPreferences.getInstance();

    _isDarkMode = preferences.getBool('isDarkMode') ?? _isDarkMode;
    _serverAddress = preferences.getString('serverAddress') ?? _serverAddress;
    _serverPort = preferences.getString('serverPort') ?? _serverPort;

    _showReading = preferences.getBool('showReading') ?? _showReading;
    _consumption = preferences.getBool('showConsumption') ?? _consumption;
    _showTemperature = preferences.getBool('showTemperature') ?? _showTemperature;
    _showFeelsLike = preferences.getBool('showFeelsLike') ?? _showFeelsLike;
    _daddysSelectedView = preferences.getString('daddysSelectedView') ?? _daddysSelectedView;
    _daddysAggregation = preferences.getString('daddysAggregation') ?? _daddysAggregation;

    notifyListeners();
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Update server address
  Future<void> updateServerAddress(String address) async {
    _serverAddress = address;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('serverAddress', _serverAddress);
    notifyListeners();
  }

  // Update server port
  Future<void> updateServerPort(String port) async {
    _serverPort = port;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('serverPort', _serverPort);
    notifyListeners();
  }

  // Toggle showReading
  Future<void> toggleShowReading() async {
    _showReading = !_showReading;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('showReading', _showReading);
    notifyListeners();
  }

  // Toggle showConsumption
  Future<void> toggleShowConsumption() async {
    _consumption = !_consumption;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('showConsumption', _consumption);
    notifyListeners();
  }

  // Toggle showTemperature
  Future<void> toggleShowTemperature() async {
    _showTemperature = !_showTemperature;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('showTemperature', _showTemperature);
    notifyListeners();
  }

  // Toggle showFeelsLike
  Future<void> toggleShowFeelsLike() async {
    _showFeelsLike = !_showFeelsLike;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('showFeelsLike', _showFeelsLike);
    notifyListeners();
  }


  // Toggle showAverage
  Future<void> setShowDaddysAggregation(String newValue) async {
    _daddysAggregation = newValue;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('daddysAggregation', _daddysAggregation);
    notifyListeners();
  }

  // Update daddy's selected view
  Future<void> updateDaddysSelectedView(String selectedView) async {
    _daddysSelectedView = selectedView;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('daddysSelectedView', _daddysSelectedView);
    notifyListeners();
  }

  // Update daddy's selected view
  Future<void> setDaddysSelectedView(String selectedView) async {
    _daddysSelectedView = selectedView;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('daddysSelectedView', _daddysSelectedView);
    notifyListeners();
  }
}
