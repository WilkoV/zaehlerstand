import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const darkModeKey = 'isDarkMode';

  static const serverAdressKey = 'serverAddress';
  static const serverPortKey = 'serverPort';

  static const showReadingKey = 'showReading';
  static const showConsumptionKey = 'showConsumption';
  static const showTemperatureKey = 'showTemperature';
  static const showFeelsLikeKey = 'showFeelsLike';

  static const daddysSelectedViewKey = 'daddysSelectedView';
  static const daddysAggregationKey = 'daddysAggregation';

  static const dashboardDaysTabletKey = 'dashboardTabletDays';
  static const dashboardMonthsTabletKey = 'dashboardTabletMonths';
  static const dashboardYearsTabletKey = 'dashboardTabletYears';

  static const dashboardDaysMobileKey = 'dashboardMobileDays';
  static const dashboardMonthsMobileKey = 'dashboardMobileMonths';
  static const dashboardYearsMobileKey = 'dashboardMobileYears';

  static const lastSelectedViewIndexKey = 'lastSelectedViewIndex';

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

  List<int> _dashboardDaysTablet = [1, 7, 30, 365];
  List<int> _dashboardMonthsTablet = [1, 2, 6, 13];
  List<int> _dashboardYearsTablet = [1, 2, 3, 4];

  List<int> _dashboardDaysMobile = [1, 30, 365];
  List<int> _dashboardMonthsMobile = [1, 6, 13];
  List<int> _dashboardYearsMobile = [1, 3, 4];

  int _lastSelectedViewIndex = 0;

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

  List<int> get dashboardDaysTablet => _dashboardDaysTablet;
  List<int> get dashboardMonthsTablet => _dashboardMonthsTablet;
  List<int> get dashboardYearsTablet => _dashboardYearsTablet;

  List<int> get dashboardDaysMobile => _dashboardDaysMobile;
  List<int> get dashboardMonthsMobile => _dashboardMonthsMobile;
  List<int> get dashboardYearsMobile => _dashboardYearsMobile;

  int get lastSelectedViewIndex => _lastSelectedViewIndex;

  // Helper method to convert comma-separated string to int list
  List<int> _stringToIntList(String? value) {
    if (value == null || value.isEmpty) return [];
    return value.split(',').map((e) => int.tryParse(e) ?? 0).toList();
  }

  // Helper method to convert int list to comma-separated string
  String _intListToString(List<int> list) {
    return list.join(',');
  }

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

    _dashboardDaysTablet = _stringToIntList(preferences.getString(dashboardDaysTabletKey) ?? _intListToString(_dashboardDaysTablet));
    _dashboardMonthsTablet = _stringToIntList(preferences.getString(dashboardMonthsTabletKey) ?? _intListToString(_dashboardMonthsTablet));
    _dashboardYearsTablet = _stringToIntList(preferences.getString(dashboardYearsTabletKey) ?? _intListToString(_dashboardYearsTablet));

    _dashboardDaysTablet = _stringToIntList(preferences.getString(dashboardDaysTabletKey) ?? _intListToString(_dashboardDaysTablet));
    _dashboardMonthsTablet = _stringToIntList(preferences.getString(dashboardMonthsTabletKey) ?? _intListToString(_dashboardMonthsTablet));
    _dashboardYearsTablet = _stringToIntList(preferences.getString(dashboardYearsTabletKey) ?? _intListToString(_dashboardYearsTablet));

    _lastSelectedViewIndex = preferences.getInt(lastSelectedViewIndexKey) ?? _lastSelectedViewIndex;

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(darkModeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> updateServerAddress(String address) async {
    _serverAddress = address;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(serverAdressKey, _serverAddress);
    notifyListeners();
  }

  Future<void> updateServerPort(String port) async {
    _serverPort = port;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(serverPortKey, _serverPort);
    notifyListeners();
  }

  Future<void> toggleShowReading() async {
    _showReading = !_showReading;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(showReadingKey, _showReading);
    notifyListeners();
  }

  Future<void> toggleShowConsumption() async {
    _consumption = !_consumption;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(showConsumptionKey, _consumption);
    notifyListeners();
  }

  Future<void> toggleShowTemperature() async {
    _showTemperature = !_showTemperature;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(showTemperatureKey, _showTemperature);
    notifyListeners();
  }

  Future<void> toggleShowFeelsLike() async {
    _showFeelsLike = !_showFeelsLike;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(showFeelsLikeKey, _showFeelsLike);
    notifyListeners();
  }

  Future<void> setShowDaddysAggregation(String newValue) async {
    _daddysAggregation = newValue;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(daddysAggregationKey, _daddysAggregation);
    notifyListeners();
  }

  Future<void> updateDaddysSelectedView(String selectedView) async {
    _daddysSelectedView = selectedView;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(daddysSelectedViewKey, _daddysSelectedView);
    notifyListeners();
  }

  Future<void> setDaddysSelectedView(String selectedView) async {
    _daddysSelectedView = selectedView;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(daddysSelectedViewKey, _daddysSelectedView);
    notifyListeners();
  }

  Future<void> updateDashboardDaysTablet(List<int> days) async {
    _dashboardDaysTablet = days;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dashboardDaysTabletKey, _intListToString(days));
    notifyListeners();
  }

  Future<void> updateDashboardMonthsTablet(List<int> months) async {
    _dashboardMonthsTablet = months;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dashboardMonthsTabletKey, _intListToString(months));
    notifyListeners();
  }

  Future<void> updateDashboardYearsTablet(List<int> years) async {
    _dashboardYearsTablet = years;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dashboardYearsTabletKey, _intListToString(years));
    notifyListeners();
  }

  Future<void> updateDashboardDaysMobile(List<int> days) async {
    _dashboardDaysMobile = days;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dashboardDaysMobileKey, _intListToString(days));
    notifyListeners();
  }

  Future<void> updateDashboardMonthsMobile(List<int> months) async {
    _dashboardMonthsMobile = months;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dashboardMonthsMobileKey, _intListToString(months));
    notifyListeners();
  }

  Future<void> updateDashboardYearsMobile(List<int> years) async {
    _dashboardYearsMobile = years;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dashboardYearsMobileKey, _intListToString(years));
    notifyListeners();
  }

  Future<void> updateLastSelectedViewIndex(int index) async {
    _lastSelectedViewIndex = index;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(lastSelectedViewIndexKey, _lastSelectedViewIndex);
    notifyListeners();
  }

  Future<void> loadLastSelectedViewIndex() async {
    final preferences = await SharedPreferences.getInstance();
    _lastSelectedViewIndex = preferences.getInt(lastSelectedViewIndexKey) ?? 0;
    notifyListeners();
  }
}
