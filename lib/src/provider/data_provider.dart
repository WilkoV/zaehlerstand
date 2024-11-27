import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/constants/provider_status.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:zaehlerstand/src/io/googlesheets/google_sheets_helper.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

class DataProvider extends ChangeNotifier {
  static final _log = Logger('DataProvider');

  /// Tracks the current status of the provider (e.g., loading, idle, syncing).
  ProviderStatus status = ProviderStatus.loading;

  /// List of all meter readings managed by the provider.
  List<MeterReading> meterReadings = <MeterReading>[];

  // All meter readings grouped by year
  Map<int, List<MeterReading>> groupedMeterReadings = {};

  /// All dailyConsumptions based on meterReadings grouped by year
  Map<int, List<DailyConsumption>> groupedDailyConsumptions = {};

  /// List of all years that have data in meterReadings
  List<int> dataYears = <int>[];

  // TODO: Check if current year in Google Sheets has more records than the local database

  /// Initializes the provider by checking if the database has data.
  /// If the database is empty, data is fetched from Google Sheets and imported.
  Future<void> initialize() async {
    _log.fine('Initialization started');
    status = ProviderStatus.loading;

    try {
      // Check database for data and load it if necessary
      await _checkIfDbHasData();

      await _checkForUnsynchronizedDbRecords();

      await _refreshLists();
      notifyListeners();
    } catch (e, stackTrace) {
      _log.severe('Failed to check DB or load from Google Sheets: $e', e, stackTrace);
      return;
    }

    status = ProviderStatus.idle;
    _log.fine('Initialization finished');
    notifyListeners(); // Notify UI listeners that state has changed
  }

  /// Fetches all meter readings from the database and updates the provider's state.
  Future<void> getAllMeterReadings() async {
    _log.fine('Fetching all meter readings from the database');
    status = ProviderStatus.loading;

    // Load readings from the database
    await _getAllMeterReadings();

    await _refreshLists();
    notifyListeners();

    status = ProviderStatus.idle;
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Fetches a list of distinct years for which meter readings exist.
  Future<void> getDataYears() async {
    _log.fine('Fetching distinct years from the database');
    status = ProviderStatus.loading;

    // Query the database for distinct years
    await _getDataYears();

    await _refreshLists();
    notifyListeners();

    status = ProviderStatus.idle;

    notifyListeners();
  }

  /// Adds a new meter reading to the database and refreshes the list of readings.
  Future<int> addMeterReading(int enteredReading) async {
    List<MeterReading> intermediateMeterReadings = _createMeterReadingsForIntermediateDays(enteredReading);

    // Add the entered reading to the intermediateMeterReadings list
    MeterReading meterReadingFromInput = MeterReading.fromInput(enteredReading);
    _log.fine('Adding user-entered reading: ${meterReadingFromInput.toString()}.');
    intermediateMeterReadings.add(meterReadingFromInput);

    // Insert all new meter readings into the database
    DatabaseHelper.bulkInsert(intermediateMeterReadings);
    _log.fine('Bulk-inserted new reading(s) into the database.');

    // Refresh data views after inserting readings
    await _refreshLists();
    notifyListeners();

    // Sync the readings with Google Sheets
    int numberOfRecordsAdded = await _syncToGoogleSheets(intermediateMeterReadings);
    await _refreshLists();
    notifyListeners();

    return numberOfRecordsAdded;
  }

  /// Deletes all meter readings from the database and refreshes the list.
  Future<void> deleteAllMeterReadings() async {
    _log.fine('Deleting all meter readings');
    status = ProviderStatus.loading;

    // Delete all records and refresh the list
    await DatabaseHelper.deleteAllMeterReadings();

    // Update all lists
    await _refreshLists();
    notifyListeners();

    status = ProviderStatus.idle;
    _log.fine('All meter readings deleted');
  }

  /// Read all data from GoogleSheets and store it in the local database.
  /// Useful if a new device needs to be initialized
  Future<int> _copyFromGoogleSheetsToDb() async {
    int numberOfReadings = 0;

    // If the database is empty, fetch data from Google Sheets
    _log.fine('Fetching data from Google Sheets');
    GoogleSheetsHelper googleSheetsHelper = GoogleSheetsHelper();
    List<MeterReading>? readingsFromSheet = await googleSheetsHelper.fetchAll();

    if (readingsFromSheet != null && readingsFromSheet.isNotEmpty) {
      _log.fine('Fetched ${readingsFromSheet.length} entries from Google Sheets');

      // Bulk import the fetched data into the database
      DatabaseHelper.bulkInsert(readingsFromSheet);
      numberOfReadings = readingsFromSheet.length;
      _log.fine('Imported readings into the database');
    }

    return numberOfReadings;
  }

  /// Check if database has data
  Future<int> _checkIfDbHasData() async {
    _log.fine('Checking if database has data');

    // Query the database for the number of meter readings
    int numberOfReadings = await DatabaseHelper.countMeterReadings();
    _log.fine('Database currently contains $numberOfReadings entries');

    if (numberOfReadings <= 0) {
      // If the database is empty, fetch data from Google Sheets
      numberOfReadings = await _copyFromGoogleSheetsToDb();
    }

    _log.fine('Database now contains $numberOfReadings entries');
    return numberOfReadings;
  }

  /// Get the years where data has been stored for
  Future<List<int>> _getDataYears() async {
    // Query the database for distinct years
    dataYears = await DatabaseHelper.getMeterReadingsDistinctYears();
    _log.fine('Fetched ${dataYears.length} distinct years: $dataYears');
    return dataYears;
  }

  /// Get all meter readings
  Future<void> _getAllMeterReadings() async {
    meterReadings = await DatabaseHelper.getAllMeterReadings();
    _log.fine('Fetched ${meterReadings.length} meter readings');
  }

  /// Calculate the daily consumption
  void _calculateDailyConsumptionAndGroupByYear() {
    // Clear the map to ensure no duplicate data
    groupedDailyConsumptions.clear();

    // Iterate through the list of meterReadings
    for (int i = 0; i < meterReadings.length; i++) {
      MeterReading currentReading = meterReadings[i];

      // Determine the year of the current reading
      int year = currentReading.date.year;

      // For the last entry, consumption is 0
      int consumption = 0;
      if (i < meterReadings.length - 1) {
        MeterReading nextReading = meterReadings[i + 1];
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

  void _groupMeterReadingsByYear() {
    // Remove all entries
    groupedMeterReadings.clear();

    // Iterate through the meterReadings list
    for (var reading in meterReadings) {
      int year = reading.date.year; // Extract the year from the date

      // If the year is not yet a key in the map, initialize an empty list for it
      if (!groupedMeterReadings.containsKey(year)) {
        groupedMeterReadings[year] = [];
      }

      // Add the current reading to the corresponding year's list
      groupedMeterReadings[year]!.add(reading);
    }
  }

  Future<int> _syncToGoogleSheets(List<MeterReading> unsynchronizedMeterReadings) async {
    int numberOfRecordsAdded = 0;
    GoogleSheetsHelper googleSheetsHelper = GoogleSheetsHelper();

    for (var currentReading in unsynchronizedMeterReadings) {
      bool isSynced = await googleSheetsHelper.insertRow(currentReading);

      if (isSynced) {
        _log.fine('Successfully synced reading with Google Sheets: ${currentReading.toString()}.');
        await DatabaseHelper.insertMeterReading(currentReading.copyWith(isSynced: true));
        _log.fine('Updated reading as synced in the database: ${currentReading.toString()}.');
      } else {
        _log.warning('Failed to sync reading with Google Sheets: ${currentReading.toString()}.');
      }

      numberOfRecordsAdded++;
    }

    _log.fine('Completed adding meter readings. Total records added: $numberOfRecordsAdded.');
    return numberOfRecordsAdded;
  }

  List<MeterReading> _createMeterReadingsForIntermediateDays(int enteredReading) {
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);

    // Find the most recent meter reading before the current date, or create a default one if none exist
    _log.fine('Fetching the previous meter reading before $currentDate.');
    MeterReading previousMeterReading = meterReadings.isNotEmpty
        ? meterReadings.firstWhere(
            (reading) => reading.date.isBefore(currentDate),
            orElse: () => meterReadings.first,
          )
        : MeterReading.fromInput(enteredReading);

    int daysBetweenReadings = currentDate.difference(previousMeterReading.date).inDays;
    _log.fine('Days between readings: $daysBetweenReadings.');

    List<MeterReading> newMeterReadings = <MeterReading>[];

    // Check if we need to generate readings for intermediate days
    if (daysBetweenReadings > 1) {
      _log.fine('Generating intermediate meter readings for missing days.');
      int totalConsumption = enteredReading - previousMeterReading.reading;
      int averageConsumption = (totalConsumption ~/ daysBetweenReadings);

      _log.fine('Total consumption: $totalConsumption, Average consumption: $averageConsumption.');

      for (var i = 0; i < daysBetweenReadings - 1; i++) {
        int previousReading = previousMeterReading.reading;
        int calculatedReading = previousReading + averageConsumption;
        DateTime targetDate = previousMeterReading.date.add(const Duration(days: 1));
        MeterReading calculatedMeterReading = MeterReading.fromGenerateData(targetDate, calculatedReading);

        _log.fine('Generated intermediate reading: ${calculatedMeterReading.toString()}');
        newMeterReadings.add(calculatedMeterReading);

        previousMeterReading = calculatedMeterReading; // Update for the next iteration
      }
    }
    return newMeterReadings;
  }

  Future<void> _refreshLists() async {
    _log.fine('Refreshing data views.');

    await _getDataYears();
    await _getAllMeterReadings();
    _groupMeterReadingsByYear();
    _calculateDailyConsumptionAndGroupByYear();

    _log.fine('All lists updated.');
  }

  Future<void> _checkForUnsynchronizedDbRecords() async {
    List<MeterReading> unsynchronizedReadings = await DatabaseHelper.getUnsynchronizedMeterReadings();
    if (unsynchronizedReadings.isNotEmpty) {
      await _syncToGoogleSheets(unsynchronizedReadings);
    }
  }
}
