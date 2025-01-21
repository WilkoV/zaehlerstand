import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const darkModeKey = 'isDarkMode';
  static const serverAdressKey = 'serverAddress';
  static const serverPortKey = 'serverPort';
  static const showReadingKey = 'showReading';
  static const showConsumptionKey = 'showConsumption';
  static const daddysSelectedViewKey = 'daddysSelectedView';
  static const showTemperatureKey = 'showTemperature';
  static const showFeelsLikeKey = 'showFeelsLike';
  static const daddysAggregationKey = 'daddysAggregation';

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

    _isDarkMode = preferences.getBool(darkModeKey) ?? _isDarkMode;
    _serverAddress = preferences.getString(serverAdressKey) ?? _serverAddress;
    _serverPort = preferences.getString(serverPortKey) ?? _serverPort;

    _showReading = preferences.getBool(showReadingKey) ?? _showReading;
    _consumption = preferences.getBool(showConsumptionKey) ?? _consumption;
    _showTemperature = preferences.getBool(showTemperatureKey) ?? _showTemperature;
    _showFeelsLike = preferences.getBool(showFeelsLikeKey) ?? _showFeelsLike;
    _daddysSelectedView = preferences.getString(daddysSelectedViewKey) ?? _daddysSelectedView;
    _daddysAggregation = preferences.getString(daddysAggregationKey) ?? _daddysAggregation;

    notifyListeners();
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(darkModeKey, _isDarkMode);
    notifyListeners();
  }

  // Update server address
  Future<void> updateServerAddress(String address) async {
    _serverAddress = address;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(serverAdressKey, _serverAddress);
    notifyListeners();
  }

  // Update server port
  Future<void> updateServerPort(String port) async {
    _serverPort = port;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(serverPortKey, _serverPort);
    notifyListeners();
  }

  // Toggle showReading
  Future<void> toggleShowReading() async {
    _showReading = !_showReading;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(showReadingKey, _showReading);
    notifyListeners();
  }

  // Toggle showConsumption
  Future<void> toggleShowConsumption() async {
    _consumption = !_consumption;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(showConsumptionKey, _consumption);
    notifyListeners();
  }

  // Toggle showTemperature
  Future<void> toggleShowTemperature() async {
    _showTemperature = !_showTemperature;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(showTemperatureKey, _showTemperature);
    notifyListeners();
  }

  // Toggle showFeelsLike
  Future<void> toggleShowFeelsLike() async {
    _showFeelsLike = !_showFeelsLike;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(showFeelsLikeKey, _showFeelsLike);
    notifyListeners();
  }

  // Toggle showAverage
  Future<void> setShowDaddysAggregation(String newValue) async {
    _daddysAggregation = newValue;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(daddysAggregationKey, _daddysAggregation);
    notifyListeners();
  }

  // Update daddy's selected view
  Future<void> updateDaddysSelectedView(String selectedView) async {
    _daddysSelectedView = selectedView;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(daddysSelectedViewKey, _daddysSelectedView);
    notifyListeners();
  }

  // Update daddy's selected view
  Future<void> setDaddysSelectedView(String selectedView) async {
    _daddysSelectedView = selectedView;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(daddysSelectedViewKey, _daddysSelectedView);
    notifyListeners();
  }
}
