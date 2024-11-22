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

  /// Getter for the list of meter readings.
  List<MeterReading> get meterReadings => _meterReadings;

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

  /// Fetches all meter readings from the database and updates the provider's state.
  Future<void> getAllMeterReadings() async {
    _log.fine('Fetching all meter readings from the database');
    status = ProviderStatus.loading;

    // Load readings from the database
    _meterReadings = await DatabaseHelper.getAllMeterReadings();
    _log.fine('Fetched ${_meterReadings.length} meter readings');

    status = ProviderStatus.idle;
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Fetches a list of distinct years for which meter readings exist.
  Future<List<int>> getDistinctYears() async {
    _log.fine('Fetching distinct years from the database');
    status = ProviderStatus.loading;

    // Query the database for distinct years
    final years = await DatabaseHelper.getMeterReadingsDistinctYears();
    _log.fine('Fetched ${years.length} distinct years: $years');

    status = ProviderStatus.idle;
    return years;
  }

  /// Adds a new meter reading to the database and refreshes the list of readings.
  Future<void> addMeterReading(MeterReading reading) async {
    _log.fine('Adding new meter reading: $reading');

    // Insert the reading into the database and refresh the readings list
    await DatabaseHelper.insertMeterReading(reading);
    await getAllMeterReadings();

    status = ProviderStatus.idle;
  }

  /// Deletes all meter readings from the database and refreshes the list.
  Future<void> deleteAllMeterReadings() async {
    _log.fine('Deleting all meter readings');
    status = ProviderStatus.loading;

    // Delete all records and refresh the list
    await DatabaseHelper.deleteAllMeterReadings();
    await getAllMeterReadings();

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
      DatabaseHelper.bulkImport(readingsFromSheet);
      numberOfReadings = readingsFromSheet.length;
      _log.fine('Imported readings into the database');
    }

    return numberOfReadings;
  }

  /// Checks if the database has data. If not, fetches data from Google Sheets and imports it.
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
}
