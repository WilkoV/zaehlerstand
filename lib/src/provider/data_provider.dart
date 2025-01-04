import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/io/connectivity/connectivity_helper.dart';
import 'package:zaehlerstand/src/io/http/http_helper.dart';
import 'package:zaehlerstand/src/models/base/average_consumption.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/monthly_consumption.dart';
import 'package:zaehlerstand/src/models/base/yearly_consumption.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class DataProvider extends ChangeNotifier {
  static final _log = Logger('DataProvider');

  // Db
  late DbHelper _dbHelper;
  late String _serverAddress;
  late String _serverPort;
  late final VoidCallback _settingsListener;
  late final SettingsProvider _settingsProvider;

  String _oldServerAddress = '';
  String _oldServerPort = '';

  // Tracks the current status of the provider (e.g., loading, idle, syncing).
  bool isLoading = true;
  bool isAddingReadings = false;
  bool isSynchronizingToServer = false;
  int unsyncedCount = 0;

  /// List of all readings managed by the provider.
  List<Reading> readings = <Reading>[];
  List<WeatherInfo> weatherInfos = <WeatherInfo>[];

  /// All readings grouped by year
  Map<int, List<Reading>> groupedReadings = {};

  List<DailyConsumption> dailyConsumptions = <DailyConsumption>[];

  /// All dailyConsumptions based on reading grouped by year
  Map<int, List<DailyConsumption>> yearlyGroupedDailyConsumptions = {};
  List<MonthlyConsumption> monthlyConsumptions = <MonthlyConsumption>[];
  List<YearlyConsumption> yearlyConsumptions = <YearlyConsumption>[];
  List<AverageConsumption> averageConsumptions = <AverageConsumption>[];

  /// List of all years that have data in reading
  List<int> dataYears = <int>[];

  DataProvider(BuildContext context) {
    // Inject the server address from SettingsProvider
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _serverAddress = _settingsProvider.serverAddress;
    _serverPort = _settingsProvider.serverPort;
    _oldServerAddress = _serverAddress;
    _oldServerPort = _oldServerPort;

    // Listen for changes in SettingsProvider and rebuild HttpHelper
    _settingsListener = () async {
      _serverAddress = _settingsProvider.serverAddress;
      _serverPort = _settingsProvider.serverPort;

      if (_serverAddress != _oldServerAddress || _serverPort != _oldServerPort) {
        _log.info('Server configuration changed');

        isLoading = true;
        notifyListeners();

        await _copyFromServerToDb();
        await _refreshLists();

        isLoading = false;
        notifyListeners();
      }

      _oldServerAddress = _serverAddress;
      _oldServerPort = _serverPort;
    };

    _settingsProvider.addListener(_settingsListener);
  }

  @override
  void dispose() {
    _log.fine('Disposing DataProvider.');

    _settingsProvider.removeListener(_settingsListener);
    super.dispose();
  }

  /// Initializes the provider by checking if the database has data.
  /// If the database is empty, data is fetched from Server and imported.
  Future<void> initialize() async {
    _log.fine('Initialization started');
    isLoading = true;

    try {
      String dbDirectory = await _getDbPath();

      _dbHelper = DbHelper();
      await _dbHelper.initDb(dbDirectory: dbDirectory);

      // Check database for data and load it if necessary
      await _refreshLists();

      if (readings.isEmpty && await ConnectivityHelper.isConnected()) {
        await _copyFromServerToDb();
        await _refreshLists();
      }

      notifyListeners();

      // Check if the DB has records that are not saved to server
      if (unsyncedCount > 0 && await ConnectivityHelper.isConnected()) {
        _checkForUnsynchronizedDbRecords();
        notifyListeners();
      }
    } catch (e, stackTrace) {
      _log.severe('Failed to check DB or load from Server: $e', e, stackTrace);
      return;
    }

    isLoading = false;
    _log.fine('Initialization finished');
    notifyListeners(); // Notify UI listeners that state has changed
  }

  /// Fetches all readings from the database and updates the provider's state.
  Future<void> getAllReadings() async {
    _log.fine('Fetching all readings from the database');

    // Load readings from the database
    await _getAllReadings();
    await _getAllWeatherInfos();

    await _refreshLists();

    notifyListeners();
  }

  /// Fetches a list of distinct years for which readings exist.
  Future<void> getDataYears() async {
    _log.fine('Fetching distinct years from the database');

    // Query the database for distinct years
    await _getDataYears();
    await _refreshLists();

    notifyListeners();
  }

  /// Adds a new reading to the database and refreshes the list of readings.
  Future<int> addReading(int enteredReading) async {
    isAddingReadings = true;
    notifyListeners();

    // Calculate intermediate readings in case some readings are missing
    List<Reading> intermediateReadings = _createReadingsForIntermediateDays(enteredReading);

    // Add the entered reading to the intermediateReadings list
    Reading readingFromInput = Reading.fromInput(enteredReading);

    _log.fine('Adding user-entered reading: ${readingFromInput.toString()}.');
    intermediateReadings.add(readingFromInput);

    // Insert all new readings into the database
    _dbHelper.bulkInsertReadings(intermediateReadings);
    _log.fine('Bulk-inserted new reading(s) into the database.');

    // Refresh data views after inserting readings
    await _refreshLists();

    notifyListeners();

    // Sync the readings with server
    int numberOfRecordsAdded = 0;

    if (await ConnectivityHelper.isConnected()) {
      numberOfRecordsAdded = await _syncToServer(intermediateReadings);

      isAddingReadings = false;
      await _refreshLists();
    }

    notifyListeners();

    return numberOfRecordsAdded;
  }

  /// Deletes all readings from the database and refreshes the list.
  Future<void> deleteAllReadings() async {
    _log.fine('Deleting all readings');

    // Delete all records and refresh the list
    await _dbHelper.deleteAllReadings();

    // Update all lists
    await _refreshLists();
    notifyListeners();

    isLoading = false;
    _log.fine('All readings deleted');
  }

  /// Read all data from server and store it in the local database.
  /// Useful if a new device needs to be initialized
  Future<int> _copyFromServerToDb() async {
    int numberOfReadings = 0;
    int maxReadingUpdatedAt = await _dbHelper.getMaxReadingsUpdatedAt();

    // If the database is empty, fetch data from Server
    _log.fine('Fetching readings from server');
    HttpHelper httpHelper = HttpHelper(baseUrl: 'http://$_serverAddress:$_serverPort');
    List<Reading> readingsFromServer = await httpHelper.fetchReadingsAfter(maxReadingUpdatedAt);

    _log.fine('Fetched ${readingsFromServer.length} readings from server');
    if (readingsFromServer.isNotEmpty) {
      // Bulk import the fetched data into the database
      await _dbHelper.bulkInsertReadings(readingsFromServer);
      numberOfReadings = readingsFromServer.length;

      _log.fine('Imported readings into the database');
    }

    int maxWeatherInfoUpdatedAt = await _dbHelper.getMaxWeatherInfoUpdatedAt();

    // If the database is empty, fetch data from Server
    _log.fine('Fetching weather info from server');
    List<WeatherInfo> weatherInfosFromServer = await httpHelper.fetchWeatherInfoAfter(maxWeatherInfoUpdatedAt);
    _log.fine('Fetched ${weatherInfosFromServer.length} weather infos from server');

    if (weatherInfosFromServer.isNotEmpty) {
      // Bulk import the fetched data into the database
      await _dbHelper.bulkInsertWeatherInfo(weatherInfosFromServer);
      numberOfReadings = weatherInfosFromServer.length;

      _log.fine('Imported readings into the database');
    }

    httpHelper.close();

    return numberOfReadings;
  }

  /// Get the years where data has been stored for
  Future<List<int>> _getDataYears() async {
    // Query the database for distinct years
    dataYears = await _dbHelper.getReadingsDistinctYears();
    _log.fine('Fetched ${dataYears.length} distinct years: $dataYears');
    return dataYears;
  }

  /// Get all readings
  Future<void> _getAllReadings() async {
    readings = await _dbHelper.getAllReadings();
    _log.fine('Fetched ${readings.length} readings');
  }

  /// Get all weather infos
  Future<void> _getAllWeatherInfos() async {
    weatherInfos = await _dbHelper.getAllWeatherInfo();
    _log.fine('Fetched ${weatherInfos.length} weather infos');
  }

  void _calculateDailyConsumption() {
    dailyConsumptions.clear();

    for (int i = 0; i < readings.length; i++) {
      Reading currentReading = readings[i];

      int consumption = 0;
      if (i < readings.length - 1) {
        Reading nextReading = readings[i + 1];
        consumption = currentReading.reading - nextReading.reading;
      }

      DailyConsumption dailyConsumption = DailyConsumption(
        date: currentReading.date,
        consumption: consumption,
      );

      WeatherInfo? weatherInfo;

      try {
        // Add weather info to daily consumption
        weatherInfo = weatherInfos.firstWhere((element) => element.date == currentReading.date);
        _log.info('Found weather info for ${currentReading.date}: $weatherInfo');
        dailyConsumption = dailyConsumption.copyWith(
          minTemperature: weatherInfo.minTemperature,
          maxTemperature: weatherInfo.maxTemperature,
          minFeelsLike: weatherInfo.minFeelsLike,
          maxFeelsLike: weatherInfo.maxFeelsLike,
        );
      } catch (_) {}

      dailyConsumptions.add(dailyConsumption);
    }
  }

  void _calculateMonthlyConsumption() {
    monthlyConsumptions.clear();

    for (var dailyConsumption in dailyConsumptions) {
      int year = dailyConsumption.date.year;
      int month = dailyConsumption.date.month;

      MonthlyConsumption? monthlyConsumption;
      try {
        // Try to find existing monthly consumption for the current year & month
        monthlyConsumption = monthlyConsumptions.firstWhere((element) => element.year == year && element.month == month);
        // Update consumption value
        monthlyConsumption = monthlyConsumption.copyWith(consumption: monthlyConsumption.consumption + dailyConsumption.consumption);
        // Replace the old monthly consumption with the updated one
        monthlyConsumptions.removeWhere((element) => element.year == year && element.month == month);
      } catch (e) {
        // If no monthly consumption exists, create a new one
        monthlyConsumption = MonthlyConsumption(year: year, month: month, consumption: dailyConsumption.consumption);
      }

      monthlyConsumptions.add(monthlyConsumption);
    }
  }

  void _calculateAverageConsumption() {
    averageConsumptions.clear();

    final now = DateTime.now();

    // Filter and calculate averages for each period
    int calculateAverage(Iterable<DailyConsumption> consumptions) {
      if (consumptions.isEmpty) {
        return 0;
      }

      final total = consumptions.fold<int>(0, (sum, item) => sum + item.consumption);
      return (total / consumptions.length).round();
    }

    // Last 7 days
    final Iterable<DailyConsumption> last7Days = dailyConsumptions.where((dailyConsumption) => dailyConsumption.date.isAfter(now.subtract(const Duration(days: 7))));
    averageConsumptions.add(AverageConsumption(period: '7 Tage', consumption: calculateAverage(last7Days)));

    // Last 30 days
    final Iterable<DailyConsumption> last30Days = dailyConsumptions.where((dailyConsumption) => dailyConsumption.date.isAfter(now.subtract(const Duration(days: 30))));
    averageConsumptions.add(AverageConsumption(period: '30 Tage', consumption: calculateAverage(last30Days)));

    // This year
    final Iterable<DailyConsumption> thisYear = dailyConsumptions.where((entry) => entry.date.year == now.year);
    averageConsumptions.add(AverageConsumption(period: '${now.year}', consumption: calculateAverage(thisYear)));

    // Total
    final int averageTotal = calculateAverage(dailyConsumptions);
    averageConsumptions.add(AverageConsumption(period: 'Total', consumption: averageTotal));
  }

  void _calculateYearlyConsumption() {
    yearlyConsumptions.clear();

    for (var monthlyConsumption in monthlyConsumptions) {
      int year = monthlyConsumption.year;

      YearlyConsumption? yearlyConsumption;
      try {
        // Try to find existing yearly consumption for the current year
        yearlyConsumption = yearlyConsumptions.firstWhere((element) => element.year == year);
        // Update consumption value
        yearlyConsumption = yearlyConsumption.copyWith(consumption: yearlyConsumption.consumption + monthlyConsumption.consumption);
        // Replace the old yearly consumption with the updated one
        yearlyConsumptions.removeWhere((element) => element.year == year);
      } catch (e) {
        // If no yearly consumption exists, create a new one
        yearlyConsumption = YearlyConsumption(year: year, consumption: monthlyConsumption.consumption);
      }

      yearlyConsumptions.add(yearlyConsumption);
    }
  }

  void _groupedDailyConsumptionsByYear() {
    yearlyGroupedDailyConsumptions.clear();

    for (var dailyConsumption in dailyConsumptions) {
      int year = dailyConsumption.date.year;

      if (!yearlyGroupedDailyConsumptions.containsKey(year)) {
        yearlyGroupedDailyConsumptions[year] = [];
      }

      yearlyGroupedDailyConsumptions[year]!.add(dailyConsumption);
    }
  }

  void _groupReadingsByYear() {
    // Remove all entries
    groupedReadings.clear();

    // Iterate through the reading list
    for (var reading in readings) {
      int year = reading.date.year; // Extract the year from the date

      // If the year is not yet a key in the map, initialize an empty list for it
      if (!groupedReadings.containsKey(year)) {
        groupedReadings[year] = [];
      }

      // Add the current reading to the corresponding year's list
      groupedReadings[year]!.add(reading);
    }
  }

  Future<int> _syncToServer(List<Reading> unsynchronizedReadings) async {
    HttpHelper httpHelper = HttpHelper(baseUrl: 'http://$_serverAddress:$_serverPort');
    bool ok = await httpHelper.bulkInsertReadings(unsynchronizedReadings);

    if (ok) {
      List<Reading> updatedReadings = readings.map((reading) {
        return reading.copyWith(isSynced: true);
      }).toList();

      await _dbHelper.bulkInsertReadings(updatedReadings);
      _log.fine('Completed adding readings. Total records added: ${updatedReadings.length}.');
      return updatedReadings.length;
    }

    return 0;
  }

  List<Reading> _createReadingsForIntermediateDays(int enteredReading) {
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);

    // Find the most recent reading before the current date, or create a default one if none exist
    _log.fine('Fetching the previous reading before $currentDate.');
    Reading previousReading = readings.isNotEmpty
        ? readings.firstWhere(
            (reading) => reading.date.isBefore(currentDate),
            orElse: () => readings.first,
          )
        : Reading.fromInput(enteredReading);

    int daysBetweenReadings = currentDate.difference(previousReading.date).inDays;
    _log.fine('Days between readings: $daysBetweenReadings.');

    List<Reading> newReadings = <Reading>[];

    // Check if we need to generate readings for intermediate days
    if (daysBetweenReadings > 1) {
      _log.fine('Generating intermediate readings for missing days.');

      int totalConsumption = enteredReading - previousReading.reading;
      double averageConsumption = totalConsumption / daysBetweenReadings;
      double previousReadingValue = previousReading.reading.toDouble();

      _log.fine('Total consumption: $totalConsumption, Average consumption: $averageConsumption.');
      DateTime targetDate = previousReading.date;

      for (var i = 0; i < daysBetweenReadings - 1; i++) {
        previousReadingValue = previousReadingValue + averageConsumption;
        targetDate = targetDate.add(const Duration(days: 1));
        Reading calculatedReading = Reading.fromGenerateData(targetDate, previousReadingValue.toInt());

        _log.fine('Generated intermediate reading: ${calculatedReading.toString()}');
        newReadings.add(calculatedReading);
      }
    }
    return newReadings;
  }

  Future<void> _refreshLists() async {
    _log.fine('Refreshing data views.');

    await _getDataYears();
    await _getAllReadings();
    await _getAllWeatherInfos();

    _groupReadingsByYear();
    _calculateDailyConsumption();
    _groupedDailyConsumptionsByYear();
    _calculateMonthlyConsumption();
    _calculateYearlyConsumption();
    _calculateAverageConsumption();

    unsyncedCount = readings.where((reading) => !reading.isSynced).length;

    _log.fine('All lists updated.');
  }

  Future<void> _checkForUnsynchronizedDbRecords() async {
    isSynchronizingToServer = true;

    final List<Reading> unsynchronizedReadings = readings.where((reading) => !reading.isSynced).toList();
    if (unsynchronizedReadings.isNotEmpty) {
      await _syncToServer(unsynchronizedReadings);
    }

    await _refreshLists();

    isSynchronizingToServer = false;

    notifyListeners();
  }

  Reading getFirstReading() {
    return readings.isNotEmpty ? readings.first : Reading.fromInput(0);
  }

  int getAverageDailyConsumption(int numberOfDays) {
    if (readings.isEmpty) {
      return 0;
    }

    // get consumption based on groupedDailyConsumptions for the last numberOfDays
    int totalConsumption = 0;
    int totalDays = 0;

    for (var year in yearlyGroupedDailyConsumptions.keys) {
      List<DailyConsumption> dailyConsumptions = yearlyGroupedDailyConsumptions[year]!;
      for (var dailyConsumption in dailyConsumptions) {
        totalConsumption += dailyConsumption.consumption;
        totalDays++;
        if (totalDays >= numberOfDays) {
          break;
        }
      }

      if (totalDays >= numberOfDays) {
        break;
      }
    }

    return totalConsumption ~/ totalDays;
  }

  static Future<String> _getDbPath() async {
    _log.fine('Determining database path.');

    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile platforms: Store in application documents directory.
      final directory = await pp.getApplicationDocumentsDirectory();
      _log.fine('Database path for mobile: ${directory.path}');
      return directory.path;
    } else if (Platform.isWindows) {
      // Windows: Store in a temporary system directory.
      final dir = await Directory.systemTemp.createTemp();
      _log.fine('Database path for Windows: ${dir.path}');
      return dir.path;
    } else {
      // Unsupported platform: Log and throw an error.
      _log.severe('Unsupported platform encountered.');
      throw UnsupportedError("This platform is not supported");
    }
  }
}
