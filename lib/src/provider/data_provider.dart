import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
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
  late final SettingsProvider settingsProvider;

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

  Map<String, Map<String, ReadingDetail>> yearlyDayViewData = {};
  Map<String, Map<String, Map<String, ReadingDetail>>> monthlyDayViewData = <String, Map<String, Map<String, ReadingDetail>>>{};
  Map<String, Map<String, Map<String, ReadingDetailAggregation>>> monthlyAggregationViewData = <String, Map<String, Map<String, ReadingDetailAggregation>>>{};
  Map<String, Map<String, Map<String, WeeklyReadingDetail>>> weeklyAggregationViewData = <String, Map<String, Map<String, WeeklyReadingDetail>>>{};

  List<ReadingDetailAggregation> monthlyAggregationViewDataList = <ReadingDetailAggregation>[];

  /// List of all years that have data in reading
  List<int> availableYears = <int>[];

  // Isolate name server
  static const String isolateNameServerPortName = 'zaehlerstandSyncPort';
  static const String isolateNameServerTriggerWord = 'syncTriggered';
  final ReceivePort _receivePort = ReceivePort();

  DataProvider(this.settingsProvider) {
    _serverAddress = settingsProvider.serverAddress;
    _serverPort = settingsProvider.serverPort;
    _oldServerAddress = _serverAddress;
    _oldServerPort = _serverPort;

    // Listen for changes in SettingsProvider and rebuild HttpHelper
    _settingsListener = () async {
      _serverAddress = settingsProvider.serverAddress;
      _serverPort = settingsProvider.serverPort;

      if (_serverAddress != _oldServerAddress || _serverPort != _oldServerPort) {
        _log.info('Server configuration changed');

        isLoading = true;
        notifyListeners();

        await _syncAndRefreshLists();

        isLoading = false;
        notifyListeners();
      }

      _oldServerAddress = _serverAddress;
      _oldServerPort = _serverPort;
    };

    settingsProvider.addListener(_settingsListener);

    // Processing triggers from the background task
    final existingPort = IsolateNameServer.lookupPortByName(DataProvider.isolateNameServerPortName);
    if (existingPort != null) {
      _log.warning('Port already registered. Skipping new registration.');
    } else {
      IsolateNameServer.registerPortWithName(_receivePort.sendPort, DataProvider.isolateNameServerPortName);
    }

    // Listen for messages
    _receivePort.listen((message) async {
      _log.fine('Isolated name server got message $message');
      if (message == isolateNameServerTriggerWord) {
        _log.info('Background task triggered _syncAndRefreshLists via $message on isolated name server');

        bool didChange = await _syncAndRefreshLists();

        if (didChange) {
          notifyListeners();
        }

        _log.fine('_syncAndRefreshLists returned $didChange');
      }
    });
  }

  @override
  void dispose() {
    _log.fine('Disposing IsolateNameServer.');

    IsolateNameServer.removePortNameMapping(isolateNameServerPortName);
    _receivePort.close();

    _log.fine('Disposing DataProvider.');

    settingsProvider.removeListener(_settingsListener);
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
      await _syncAndRefreshLists();
    } catch (e, stackTrace) {
      _log.severe('Failed to check DB or load from Server: $e', e, stackTrace);
      return;
    }

    _log.fine('Initialization finished');

    isLoading = false;
    notifyListeners(); // Notify UI listeners that state has changed
  }

  /// Adds a new reading to the database and refreshes the list of readings.
  Future<int> addReading(int enteredReading, DateTime targetDate) async {
    _log.info('Adding reading $enteredReading');

    isAddingReadings = true;
    notifyListeners();

    List<ReadingDetail> intermediateReadingsDetails = <ReadingDetail>[];

    // Calculate intermediate days
    DateTime currentDate = targetDate;
    Reading? previousReading = currentReading ?? Reading.fromInput(enteredReading);
    int daysBetweenReadings = currentDate.difference(previousReading.date).inDays;

    _log.info('No of intermediate days: $daysBetweenReadings');

    // Calculate intermediate readings in case some readings are missing
    if (daysBetweenReadings >= 1) {
      intermediateReadingsDetails = await _createReadingsForIntermediateDays(enteredReading: enteredReading, daysBetweenReadings: daysBetweenReadings, previousReading: previousReading);
    }

    //
    int previousReadingValue = 0;

    if (intermediateReadingsDetails.isNotEmpty) {
      previousReadingValue = intermediateReadingsDetails.last.reading.reading;
    } else if (currentReading != null && currentReading!.date != currentDate) {
      previousReadingValue = currentReading!.reading;
    } else if (readingsDetails.isNotEmpty && readingsDetails.length > 2) {
      previousReadingValue = readingsDetails[1].reading.reading;
    }

    // Add the entered reading to the intermediateReadings list
    Reading readingFromInput = Reading.fromInput(enteredReading).copyWith(date: DateTime(currentDate.year, currentDate.month, currentDate.day, 12));
    Consumption consumption = Consumption(
      date: DateTime(currentDate.year, currentDate.month, currentDate.day, 12),
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
    final didUpdate = await _syncAndRefreshLists();

    if (didUpdate) {
      notifyListeners();
    }

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

  Future<void> _getYearlyDayViewData() async {
    yearlyDayViewData.clear();

    List<ReadingDetail> data = await _dbHelper.getAllReadingsDetailsDescAscAsc();

    for (var readingDetail in data) {
      final year = readingDetail.reading.date.year.toString();
      final dayMonth = "${readingDetail.reading.date.day.toString().padLeft(2, '0')}.${readingDetail.reading.date.month.toString().padLeft(2, '0')}";

      yearlyDayViewData[year] ??= {};
      yearlyDayViewData[year]![dayMonth] = readingDetail;
    }
  }

  Future<void> _getMonthlyDayViewData() async {
    monthlyDayViewData.clear();

    final currentYear = DateTime.now().year;

    List<ReadingDetail> data = await _dbHelper.getAllReadingsDetailsDescAscAsc();

    for (var readingDetail in data) {
      if (readingDetail.reading.date.year == currentYear) {
        final month = readingDetail.reading.date.month.toString().padLeft(2, '0');
        final day = readingDetail.reading.date.day.toString().padLeft(2, '0');

        monthlyDayViewData[month] ??= {};
        monthlyDayViewData[month]![day] = {"readingDetail": readingDetail};
      }
    }
  }

  Future<void> _getMonthlyAggregationViewData() async {
    monthlyAggregationViewData.clear();

    List<ReadingDetailAggregation> data = await _dbHelper.getMonthlyAggregationDescAsc();

    for (var readingDetailAggregation in data) {
      final String year = readingDetailAggregation.year.toString();
      final String month = readingDetailAggregation.month.toString().padLeft(2, '0');

      monthlyAggregationViewData[year] ??= {};
      monthlyAggregationViewData[year]![month] = {'aggregation': readingDetailAggregation};
    }
  }

  Future<void> _getWeeklyAggregationViewData() async {
    weeklyAggregationViewData.clear();

    List<WeeklyReadingDetail> data = await _dbHelper.getWeeklyReadingDetailsDescAsc();

    for (var weeklyReadingDetailAggregation in data) {
      final String week = weeklyReadingDetailAggregation.week.toString();
      final String dayInWeek = weeklyReadingDetailAggregation.dayInWeek.toString().padLeft(2, '0');

      weeklyAggregationViewData[week] ??= {};
      weeklyAggregationViewData[week]![dayInWeek] = {'aggregation': weeklyReadingDetailAggregation};
    }
  }

  Future<void> syncAndRefreshDisplay() async {
    final didUpdate = await _syncAndRefreshLists();

    if (didUpdate) {
      notifyListeners();
    }
  }

  Future<void> sync() async {
    final didUpdate = await _syncAndRefreshLists();

    if (didUpdate) {
      notifyListeners();
    }
  }

  Future<bool> _syncAndRefreshLists() async {
    _log.fine('Refreshing data views.');

    SyncManager syncManager = SyncManager();
    await syncManager.initialize();
    final bool fromServer = await syncManager.copyFromServer(_serverAddress, int.parse(_serverPort));
    final bool toServer = await syncManager.syncUnsyncedData(_serverAddress, int.parse(_serverPort));

    if (!fromServer && !toServer && readingsDetails.isNotEmpty) {
      return false;
    }

    readingsDetails.clear();
    availableYears.clear();
    monthlyAggregationViewDataList.clear();

    currentReading = await _dbHelper.getCurrentReading();
    readingsDetails = await _dbHelper.getAllReadingsDetailsDescDescDesc();
    availableYears = await _dbHelper.getReadingsDistinctYears();
    monthlyAggregationViewDataList = await _dbHelper.getMonthlyAggregationDescDesc();

    await _getYearlyDayViewData();
    await _getMonthlyDayViewData();
    await _getMonthlyAggregationViewData();
    await _getWeeklyAggregationViewData();

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

    return true;
  }
}
