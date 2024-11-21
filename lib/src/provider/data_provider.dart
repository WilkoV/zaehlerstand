import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/constants/provider_status.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:zaehlerstand/src/io/googlesheets/google_sheets_helper.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

class DataProvider extends ChangeNotifier {
  static final _log = Logger('DataProvider');

  /// Tracks the current status of the provider (e.g., loading, idle, syncing).
  ProviderStatus status = ProviderStatus.loading;

  /// List of all meter readings managed by the provider.
  List<MeterReading> _meterReadings = [];

  /// The currently selected or active meter reading.
  MeterReading? _currentReading;

  /// Getter for the list of meter readings.
  List<MeterReading> get meterReadings => _meterReadings;

  /// Getter for the current meter reading.
  MeterReading? get currentReading => _currentReading;

  /// Initializes the provider by checking if the database has data.
  /// If the database is empty, data is fetched from Google Sheets and imported.
  Future<void> initialize() async {
    _log.fine('Initialization started');
    status = ProviderStatus.loading;

    try {
      // Check database for data and load it if necessary
      await _checkIfDbHasData();
    } catch (e, stackTrace) {
      _log.severe('Failed to check DB or load from Google Sheets: $e', e, stackTrace);
      return;
    }

    // TODO: Check if current year in Google Sheets has more records than the local database
    // TODO: Publish unsynchronized data from the database to Google Sheets

    status = ProviderStatus.idle;
    _log.fine('Initialization finished');
    notifyListeners(); // Notify UI listeners that state has changed
  }

  /// Checks if the database has data. If not, fetches data from Google Sheets and imports it.
  Future<int> _checkIfDbHasData() async {
    _log.fine('Checking if database has data');

    // Query the database for the number of meter readings
    int numberOfReadings = await DatabaseHelper.countMeterReadings();
    _log.fine('Database currently contains $numberOfReadings entries');

    if (numberOfReadings <= 0) {
      // If the database is empty, fetch data from Google Sheets
      _log.fine('Fetching data from Google Sheets');
      GoogleSheetsHelper googleSheetsHelper = GoogleSheetsHelper();
      List<MeterReading>? readingsFromSheet = await googleSheetsHelper.fetchAll();

      if (readingsFromSheet != null && readingsFromSheet.isNotEmpty) {
        _log.fine('Fetched ${readingsFromSheet.length} entries from Google Sheets');

        // Bulk import the fetched data into the database
        DatabaseHelper.bulkImport(readingsFromSheet);
        numberOfReadings = readingsFromSheet.length;
        _log.fine('Imported readings into the database');
      }
    }

    _log.fine('Database now contains $numberOfReadings entries');
    return numberOfReadings;
  }

  /// Fetches all meter readings from the database and updates the provider's state.
  Future<void> fetchMeterReadings() async {
    _log.fine('Fetching all meter readings from the database');
    status = ProviderStatus.loading;

    // Load readings from the database
    _meterReadings = await DatabaseHelper.getMeterReadings();
    _log.fine('Fetched ${_meterReadings.length} meter readings');

    status = ProviderStatus.idle;
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Fetches a list of distinct years for which meter readings exist.
  Future<List<int>> fetchDistinctYears() async {
    _log.fine('Fetching distinct years from the database');
    status = ProviderStatus.loading;

    // Query the database for distinct years
    final years = await DatabaseHelper.getMeterReadingsDistinctYears();
    _log.fine('Fetched ${years.length} distinct years: $years');

    status = ProviderStatus.idle;
    return years;
  }

  /// Fetches the meter reading for a specific year.
  Future<MeterReading?> fetchReadingForYear(int year) async {
    _log.fine('Fetching meter reading for the year $year');
    status = ProviderStatus.loading;

    // Query the database for the reading for the given year
    _currentReading = await DatabaseHelper.getMeterReadingForYear(year);
    _log.fine('Fetched reading: $_currentReading');

    status = ProviderStatus.idle;
    notifyListeners(); // Notify listeners about the updated current reading
    return _currentReading;
  }

  /// Fetches the meter reading from a specific number of days before today.
  Future<MeterReading?> fetchReadingDaysBefore(int daysBefore) async {
    _log.fine('Fetching meter reading from $daysBefore days ago');
    status = ProviderStatus.loading;

    // Query the database for the reading
    _currentReading = await DatabaseHelper.getMeterReadingDaysBefore(daysBefore);
    _log.fine('Fetched reading: $_currentReading');

    status = ProviderStatus.idle;
    notifyListeners();
    return _currentReading;
  }

  /// Adds a new meter reading to the database and refreshes the list of readings.
  Future<void> addMeterReading(MeterReading reading) async {
    _log.fine('Adding new meter reading: $reading');

    // Insert the reading into the database and refresh the readings list
    await DatabaseHelper.insertMeterReading(reading);
    await fetchMeterReadings();

    status = ProviderStatus.idle;
  }

  /// Deletes all meter readings from the database and refreshes the list.
  Future<void> deleteAllReadings() async {
    _log.fine('Deleting all meter readings');
    status = ProviderStatus.loading;

    // Delete all records and refresh the list
    await DatabaseHelper.deleteAllMeterReadings();
    await fetchMeterReadings();

    status = ProviderStatus.idle;
    _log.fine('All meter readings deleted');
  }

  /// Performs a bulk import of multiple meter readings into the database.
  /// After the import, the list of readings is refreshed.
  Future<void> bulkImportMeterReadings(List<MeterReading> readings) async {
    _log.fine('Performing bulk import of ${readings.length} meter readings');
    status = ProviderStatus.syncing;

    // Bulk import readings and refresh the list
    await DatabaseHelper.bulkImport(readings);
    await fetchMeterReadings();

    status = ProviderStatus.idle;
    _log.fine('Bulk import completed');
  }
}
