import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/io/db/db_path.dart';
import 'package:zaehlerstand/src/io/sync/sync_manager.dart';
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

  /// Data sets for the UI
  double last7ConsumptionAverage = 0;
  Reading? currentReading;
  List<ReadingDetail> readingsDetails = <ReadingDetail>[];
  Map<String, Map<String, dynamic>> yearlyDayViewData = {};
  Map<String, Map<String, Map<String, dynamic>>> monthlyDayViewData = <String, Map<String, Map<String, dynamic>>>{};
  Map<String, Map<String, Map<String, ReadingDetailAggregation>>> monthlyAggregationViewData = <String, Map<String, Map<String, ReadingDetailAggregation>>>{};

  /// List of all years that have data in reading
  List<int> availableYears = <int>[];

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

        SyncManager syncManager = SyncManager();
        await syncManager.initialize();
        bool changedOnFromDb = await syncManager.copyFromServer(_serverAddress, int.parse(_serverPort));
        bool changedOnSync = await syncManager.syncUnsyncedData(_serverAddress, int.parse(_serverPort));

        if (changedOnFromDb || changedOnSync) {
          await _refreshLists();
        }

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
    notifyListeners();

    try {
      String dbDirectory = await DbPath.get();

      _dbHelper = DbHelper();
      await _dbHelper.initDb(dbDirectory: dbDirectory);

      // Check database for data and load it if necessary
      await _refreshLists();

      notifyListeners();

      SyncManager syncManager = SyncManager();
      await syncManager.initialize();
      await syncManager.copyFromServer(_serverAddress, int.parse(_serverPort));
      await syncManager.syncUnsyncedData(_serverAddress, int.parse(_serverPort));
      //   // _checkForUnsynchronizedDbRecords();
      //   notifyListeners();
      // }
    } catch (e, stackTrace) {
      _log.severe('Failed to check DB or load from Server: $e', e, stackTrace);
      return;
    }

    _log.fine('Initialization finished');

    isLoading = false;
    notifyListeners(); // Notify UI listeners that state has changed
  }

  /// Adds a new reading to the database and refreshes the list of readings.
  Future<int> addReading(int enteredReading) async {
    _log.info('Adding reading $enteredReading');

    isAddingReadings = true;
    notifyListeners();

    List<ReadingDetail> intermediateReadingsDetails = <ReadingDetail>[];

    // Calculate intermediate days
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);
    Reading? previousReading = currentReading ?? Reading.fromInput(enteredReading);
    int daysBetweenReadings = currentDate.difference(previousReading.date).inDays - 1;

    _log.info('No of intermediate days: $daysBetweenReadings');

    // Calculate intermediate readings in case some readings are missing
    if (daysBetweenReadings > 1) {
      intermediateReadingsDetails = await _createReadingsForIntermediateDays(enteredReading: enteredReading, daysBetweenReadings: daysBetweenReadings, previousReading: previousReading);
    }

    //
    int previousReadingValue = 0;

    if (intermediateReadingsDetails.isNotEmpty) {
      previousReadingValue = intermediateReadingsDetails.last.reading.reading;
    }
    if (currentReading != null && currentReading!.date != currentDate) {
      previousReadingValue = currentReading!.reading;
    } else if (readingsDetails.isNotEmpty && readingsDetails.length > 2) {
      previousReadingValue = readingsDetails[1].reading.reading;
    }

    // Add the entered reading to the intermediateReadings list
    Reading readingFromInput = Reading.fromInput(enteredReading);
    Consumption consumption = Consumption(
      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
      consumption: readingFromInput.reading - previousReadingValue,
      isGenerated: false,
      isSynced: false,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    _log.fine('Adding user-entered reading: ${readingFromInput.toString()}.');

    intermediateReadingsDetails.add(ReadingDetail(reading: readingFromInput, consumption: consumption));

    // Insert all new readings into the database
    List<Reading> readings = [];
    List<Consumption> consumptions = [];

    for (var detail in intermediateReadingsDetails) {
      readings.add(detail.reading);
      if (detail.consumption != null) {
        consumptions.add(detail.consumption!);
      }
    }

    _dbHelper.bulkInsertReadings(readings);
    _log.fine('Bulk-inserted new reading(s) into the database.');

    _dbHelper.bulkInsertConsumptions(consumptions);
    _log.fine('Bulk-inserted new consumption(s) into the database.');

    // Refresh data views after inserting readings

    await _refreshLists();

    notifyListeners();

    return intermediateReadingsDetails.length;
  }

  Future<List<ReadingDetail>> _createReadingsForIntermediateDays({required int enteredReading, required daysBetweenReadings, required Reading previousReading}) async {
    // Initialize result list
    List<ReadingDetail> intermediateReadingsDetails = <ReadingDetail>[];

    _log.info('Generating intermediate readings for missing days.');

    // Calculate total consumptions for the intermediate days
    int totalConsumption = enteredReading - previousReading.reading;

    // Calculate average consumption
    double averageConsumption = totalConsumption / (daysBetweenReadings + 1);

    _log.info('Total consumption: $totalConsumption, Average consumption: $averageConsumption.');

    // Initialize loop data
    DateTime targetDate = previousReading.date;
    int previousReadingValue = previousReading.reading;
    double intermediateReadingValue = previousReadingValue.toDouble();

    _log.info('Initial loop data: intermediate reading value: $intermediateReadingValue, previous reading value: $previousReadingValue, targetDate: ${targetDate.year}/${targetDate.month}/${targetDate.day}');

    for (var i = 0; i < daysBetweenReadings; i++) {
      // Calculate intermediate consumption
      intermediateReadingValue = intermediateReadingValue + averageConsumption;

      // Increase target date
      targetDate = targetDate.add(const Duration(days: 1));

      _log.info('Loop data: intermediate reading value: $intermediateReadingValue, previous reading value: $previousReadingValue, targetDate: ${targetDate.year}/${targetDate.month}/${targetDate.day}');

      // Create intermediate reading
      Reading intermediateReading = Reading.fromGenerateData(targetDate, intermediateReadingValue.toInt());
      Consumption intermediateConsumption = Consumption(
        date: targetDate,
        consumption: intermediateReading.reading - previousReadingValue,
        isGenerated: true,
        isSynced: false,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      intermediateReadingsDetails.add(ReadingDetail(reading: intermediateReading, consumption: intermediateConsumption));

      previousReadingValue = intermediateReading.reading;

      _log.fine('Generated intermediate reading: ${intermediateReading.toString()}');
      _log.fine('Generated intermediate reading: ${intermediateConsumption.toString()}');
    }

    return intermediateReadingsDetails;
  }

  Future<void> _createYearlyDayViewData() async {
    yearlyDayViewData.clear();

    List<ReadingDetail> data = await _dbHelper.getAllReadingsDetailsDescAscAsc();

    for (var readingDetail in data) {
      final year = readingDetail.reading.date.year.toString();
      final dayMonth = "${readingDetail.reading.date.day.toString().padLeft(2, '0')}.${readingDetail.reading.date.month.toString().padLeft(2, '0')}";

      yearlyDayViewData[year] ??= {};
      yearlyDayViewData[year]![dayMonth] = {
        "enteredReading": readingDetail.reading.enteredReading,
        "reading": readingDetail.reading.reading,
        if (readingDetail.consumption != null) "consumption": readingDetail.consumption?.consumption,
        if (readingDetail.weatherInfo != null) "minTemperature": readingDetail.weatherInfo?.minTemperature,
        if (readingDetail.weatherInfo != null) "maxTemperature": readingDetail.weatherInfo?.maxTemperature,
        if (readingDetail.weatherInfo != null) "minFeelsLike": readingDetail.weatherInfo?.minFeelsLike,
        if (readingDetail.weatherInfo != null) "maxFeelsLike": readingDetail.weatherInfo?.maxFeelsLike,
      };
    }
  }

  Future<void> _createMonthlyDayViewData() async {
    monthlyDayViewData.clear();

    final currentYear = DateTime.now().year;

    List<ReadingDetail> data = await _dbHelper.getAllReadingsDetailsDescAscAsc();

    for (var readingDetail in data) {
      if (readingDetail.reading.date.year == currentYear) {
        final month = readingDetail.reading.date.month.toString().padLeft(2, '0');
        final day = readingDetail.reading.date.day.toString().padLeft(2, '0');

        monthlyDayViewData[month] ??= {};
        monthlyDayViewData[month]![day] = {
          "enteredReading": readingDetail.reading.enteredReading,
          "reading": readingDetail.reading.reading,
          if (readingDetail.consumption != null) "consumption": readingDetail.consumption?.consumption,
          if (readingDetail.weatherInfo != null) "minTemperature": readingDetail.weatherInfo?.minTemperature,
          if (readingDetail.weatherInfo != null) "maxTemperature": readingDetail.weatherInfo?.maxTemperature,
          if (readingDetail.weatherInfo != null) "minFeelsLike": readingDetail.weatherInfo?.minFeelsLike,
          if (readingDetail.weatherInfo != null) "maxFeelsLike": readingDetail.weatherInfo?.maxFeelsLike,
        };
      }
    }
  }

  Future<void> _createMonthlyAggregationViewData() async {
    monthlyAggregationViewData.clear();

    List<ReadingDetailAggregation> data = await _dbHelper.getMonthlyAggregationDescAsc();

    for (var readingDetailAggregation in data) {
      final String year = readingDetailAggregation.year.toString();
      final String month = readingDetailAggregation.month.toString().padLeft(2, '0');

      monthlyAggregationViewData[year] ??= {};
      monthlyAggregationViewData[year]![month] = {'aggregation': readingDetailAggregation};
    }
  }

  Future<void> _refreshLists() async {
    _log.fine('Refreshing data views.');

    SyncManager syncManager = SyncManager();
    await syncManager.initialize();
    await syncManager.copyFromServer(_serverAddress, int.parse(_serverPort));
    await syncManager.syncUnsyncedData(_serverAddress, int.parse(_serverPort));

    currentReading = await _dbHelper.getCurrentReading();

    readingsDetails = await _dbHelper.getAllReadingsDetailsDescDescDesc();
    availableYears = await _dbHelper.getReadingsDistinctYears();

    _createYearlyDayViewData();
    _createMonthlyDayViewData();
    _createMonthlyAggregationViewData();

    try {
      last7ConsumptionAverage = await _dbHelper.getAverageConsumptionOfLast7Days();
    } on Exception catch (e) {
      _log.severe(e);
    }

    //  TODO: Implement
    // await _getDataYears();
    // await _getAllReadings();
    // await _getAllConsumptions();
    // await _getAllWeatherInfos();

    // unsyncedCount = readings.where((reading) => !reading.isSynced).length;

    _log.fine('All lists updated.');
  }
}
