import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:zaehlerstand/src/io/googlesheets/google_sheets_helper.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/progress_update.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';

class DataProvider extends ChangeNotifier {
  static final _log = Logger('DataProvider');

  /// Tracks the current status of the provider (e.g., loading, idle, syncing).
  bool isLoading = true;
  bool isAddingReadings = false;
  bool isSynchronizingToGoogleSheets = false;
  int unsyncedCount = 0;

  /// List of all meter readings managed by the provider.
  List<Reading> readings = <Reading>[];

  // All meter readings grouped by year
  Map<int, List<Reading>> groupedReadings = {};

  /// All dailyConsumptions based on reading grouped by year
  Map<int, List<DailyConsumption>> groupedDailyConsumptions = {};

  /// List of all years that have data in reading
  List<int> dataYears = <int>[];

  final StreamController<ProgressUpdate> _addReadingProgressController;
  final StreamController<ProgressUpdate> _syncReadingProgressController;

  Stream<ProgressUpdate> get addReadingsProgressStream => _addReadingProgressController.stream;
  Stream<ProgressUpdate> get syncReadingsProgressStream => _syncReadingProgressController.stream;

  DataProvider()
      : _addReadingProgressController = StreamController<ProgressUpdate>.broadcast(),
        _syncReadingProgressController = StreamController<ProgressUpdate>.broadcast() {
    _log.fine('DataProvider initialized.');
  }

  @override
  void dispose() {
    _log.fine('Disposing DataProvider.');

    // Close StreamControllers
    _addReadingProgressController.close();
    _syncReadingProgressController.close();

    super.dispose();
  }

  /// Initializes the provider by checking if the database has data.
  /// If the database is empty, data is fetched from Google Sheets and imported.
  Future<void> initialize() async {
    _log.fine('Initialization started');
    isLoading = true;

    try {
      // Check database for data and load it if necessary
      await _refreshLists();

      if (readings.isEmpty) {
        await _copyFromGoogleSheetsToDb();
        await _refreshLists();
      }

      notifyListeners();

      // Check if the DB has records that are not saved to google sheets
      if (unsyncedCount > 0) {
        _checkForUnsynchronizedDbRecords();
        notifyListeners();
      }
    } catch (e, stackTrace) {
      _log.severe('Failed to check DB or load from Google Sheets: $e', e, stackTrace);
      return;
    }

    isLoading = false;
    _log.fine('Initialization finished');
    notifyListeners(); // Notify UI listeners that state has changed
  }

  /// Fetches all meter readings from the database and updates the provider's state.
  Future<void> getAllReadings() async {
    _log.fine('Fetching all meter readings from the database');

    // Load readings from the database
    await _getAllReadings();
    await _refreshLists();

    notifyListeners();
  }

  /// Fetches a list of distinct years for which meter readings exist.
  Future<void> getDataYears() async {
    _log.fine('Fetching distinct years from the database');

    // Query the database for distinct years
    await _getDataYears();
    await _refreshLists();

    notifyListeners();
  }

  /// Adds a new meter reading to the database and refreshes the list of readings.
  Future<int> addReading(int enteredReading) async {
    isAddingReadings = true;
    notifyListeners();

    // Calculate intermediate readings in case some readings are missing
    List<Reading> intermediateReadings = _createReadingsForIntermediateDays(enteredReading);

    // Add the entered reading to the intermediateReadings list
    Reading readingFromInput = Reading.fromInput(enteredReading);
    _log.fine('Adding user-entered reading: ${readingFromInput.toString()}.');
    intermediateReadings.add(readingFromInput);

    // Insert all new meter readings into the database
    DatabaseHelper.bulkInsert(intermediateReadings);
    _log.fine('Bulk-inserted new reading(s) into the database.');

    // Refresh data views after inserting readings
    await _refreshLists();

    notifyListeners();

    // Sync the readings with Google Sheets
    int numberOfRecordsAdded = await _syncToGoogleSheets(
      intermediateReadings,
      (progress) {
        _addReadingProgressController.add(progress);
        _log.fine('addReading progress: ${progress.current} of ${progress.total}');
      },
    );

    isAddingReadings = false;
    await _refreshLists();

    notifyListeners();

    return numberOfRecordsAdded;
  }

  /// Deletes all meter readings from the database and refreshes the list.
  Future<void> deleteAllReadings() async {
    _log.fine('Deleting all meter readings');

    // Delete all records and refresh the list
    await DatabaseHelper.deleteAllReadings();

    // Update all lists
    await _refreshLists();
    notifyListeners();

    isLoading = false;
    _log.fine('All meter readings deleted');
  }

  /// Read all data from GoogleSheets and store it in the local database.
  /// Useful if a new device needs to be initialized
  Future<int> _copyFromGoogleSheetsToDb() async {
    int numberOfReadings = 0;

    // If the database is empty, fetch data from Google Sheets
    _log.fine('Fetching data from Google Sheets');
    GoogleSheetsHelper googleSheetsHelper = GoogleSheetsHelper();
    List<Reading>? readingsFromSheet = await googleSheetsHelper.fetchAll();

    if (readingsFromSheet != null && readingsFromSheet.isNotEmpty) {
      _log.fine('Fetched ${readingsFromSheet.length} entries from Google Sheets');

      // Bulk import the fetched data into the database
      DatabaseHelper.bulkInsert(readingsFromSheet);
      numberOfReadings = readingsFromSheet.length;
      _log.fine('Imported readings into the database');
    }

    return numberOfReadings;
  }

  /// Get the years where data has been stored for
  Future<List<int>> _getDataYears() async {
    // Query the database for distinct years
    dataYears = await DatabaseHelper.getReadingsDistinctYears();
    _log.fine('Fetched ${dataYears.length} distinct years: $dataYears');
    return dataYears;
  }

  /// Get all meter readings
  Future<void> _getAllReadings() async {
    readings = await DatabaseHelper.getAllReadings();
    _log.fine('Fetched ${readings.length} meter readings');
  }

  /// Calculate the daily consumption
  void _calculateDailyConsumptionAndGroupByYear() {
    // Clear the map to ensure no duplicate data
    groupedDailyConsumptions.clear();

    // Iterate through the list of reading
    for (int i = 0; i < readings.length; i++) {
      Reading currentReading = readings[i];

      // Determine the year of the current reading
      int year = currentReading.date.year;

      // For the last entry, consumption is 0
      int consumption = 0;
      if (i < readings.length - 1) {
        Reading nextReading = readings[i + 1];
        consumption = currentReading.reading - nextReading.reading;
      }

      // Create a DailyConsumption object
      DailyConsumption dailyConsumption = DailyConsumption(
        date: currentReading.date,
        value: consumption,
      );

      // Add the consumption to the corresponding year in the map
      if (!groupedDailyConsumptions.containsKey(year)) {
        groupedDailyConsumptions[year] = [];
      }
      groupedDailyConsumptions[year]!.add(dailyConsumption);
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

  Future<int> _syncToGoogleSheets(List<Reading> unsynchronizedReadings, Function(ProgressUpdate) onProgress) async {
    GoogleSheetsHelper googleSheetsHelper = GoogleSheetsHelper();

    List<Reading> synchronizedReadings = await googleSheetsHelper.insertRows(unsynchronizedReadings, onProgress);

    await DatabaseHelper.bulkInsert(synchronizedReadings);

    _log.fine('Completed adding meter readings. Total records added: ${synchronizedReadings.length}.');
    return synchronizedReadings.length;
  }

  List<Reading> _createReadingsForIntermediateDays(int enteredReading) {
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);

    // Find the most recent meter reading before the current date, or create a default one if none exist
    _log.fine('Fetching the previous meter reading before $currentDate.');
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
      _log.fine('Generating intermediate meter readings for missing days.');

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
    _groupReadingsByYear();
    _calculateDailyConsumptionAndGroupByYear();
    unsyncedCount = readings.where((reading) => !reading.isSynced).length;

    _log.fine('All lists updated.');
  }

  Future<void> _checkForUnsynchronizedDbRecords() async {
    isSynchronizingToGoogleSheets = true;

    final List<Reading> unsynchronizedReadings = readings.where((reading) => !reading.isSynced).toList();
    if (unsynchronizedReadings.isNotEmpty) {
      await _syncToGoogleSheets(
        unsynchronizedReadings,
        (progress) {
          _syncReadingProgressController.add(progress);
          _log.fine('Check for unsynchronized progress: ${progress.current} of ${progress.total}');
        },
      );
    }

    await _refreshLists();

    isSynchronizingToGoogleSheets = false;

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

    for (var year in groupedDailyConsumptions.keys) {
      List<DailyConsumption> dailyConsumptions = groupedDailyConsumptions[year]!;
      for (var dailyConsumption in dailyConsumptions) {
        totalConsumption += dailyConsumption.value;
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
}
