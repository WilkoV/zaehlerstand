import 'package:gsheets/gsheets.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/constants/google_sheets_credentials.dart' as gsc;
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/models/base/progress_update.dart';
import 'package:zaehlerstand/src/models/logic/meter_reading_logic.dart';

class GoogleSheetsHelper {
  final Logger _log = Logger('GoogleSheetsHelper');

  int credentialId = 1;

  // TODO: Implement logic to get the total count of rows in all worksheets
  // TODO: Implement logic to get the last entry by date across all worksheets

  Future<List<MeterReading>> insertRows(List<MeterReading> readings, Function(ProgressUpdate) onProgress) async {
    late Spreadsheet spreadsheet;
    late Worksheet? worksheet;

    List<MeterReading> synchronizedMeterReadings = <MeterReading>[];

    bool switched = false;
    bool failed = false;

    final total = readings.length;
    int recordIndex = 1;

    int numberOfInserts = 0;

    // Fetch the spreadsheet and the specific worksheet by title (year)

    for (MeterReading reading in readings) {
      if (numberOfInserts == 0) {
        switched = true;
      } else if (failed) {
        switched = await _updateCredentialId(numberOfInserts: numberOfInserts, forceSwitch: true);
      } else {
        switched = await _updateCredentialId(numberOfInserts: numberOfInserts);
      }

      if (switched) {
        try {
          _log.fine('Getting spreadsheet with credentialId $credentialId');
          spreadsheet = await _getSheet(credentialId: credentialId - 1);

          _log.fine('Getting worksheet');
          worksheet = await _getWorksheetByTitle(spreadsheet, _getWorksheetTitle(reading));
        } catch (e, stackTrace) {
          _log.severe('Failed to get sheets: $e', e, stackTrace);
          return synchronizedMeterReadings;
        }
      }

      // Ensure the worksheet exists
      if (worksheet != null) {
        _log.fine('Sheets loaded');
      } else {
        _log.warning('Worksheet is null, cannot insert row.');
        return synchronizedMeterReadings;
      }

      // Insert the row data at the specific row index (day of the year)
      try {
        final bool ok = await worksheet.values.insertRow(reading.getDayOfYear(), reading.toDynamicList());

        if (ok) {
          synchronizedMeterReadings.add(reading.copyWith(isSynced: true));
        }

        numberOfInserts++;
      } catch (e, stackTrace) {
        _log.severe('Failed to insert row: $e', e, stackTrace);
        failed = true;
      }

      onProgress(ProgressUpdate(current: recordIndex, total: total));
      recordIndex++;
    }

    _log.fine('${synchronizedMeterReadings.length} written to google sheets');

    return synchronizedMeterReadings;
  }

  /// Fetches all rows for the given [year] from the corresponding worksheet.
  /// Converts each row into a [MeterReading] object and returns a list.
  Future<List<MeterReading>?> fetchYear(String year) async {
    try {
      _log.fine('Fetching data for the year: $year');

      // Fetch the spreadsheet and the worksheet by title (year)
      final Spreadsheet spreadsheet = await _getSheet();
      final Worksheet? worksheet = await _getWorksheetByTitle(spreadsheet, year);

      // Ensure the worksheet exists
      if (worksheet == null) {
        _log.warning('Worksheet is null, cannot fetch rows.');
        return null;
      }

      // Fetch all rows from the worksheet
      List<List<String>> result = await _fetchWorksheet(worksheet);

      // Convert rows into MeterReading objects
      List<MeterReading> readings = MeterReadingLogic.fromListOfStringLists(result);

      _log.fine('Fetched rows: ${result.toString()}');
      return readings;
    } catch (e, stackTrace) {
      _log.severe("Failed to fetch rows for the year: $e", e, stackTrace);
      return null;
    }
  }

  /// Fetches all rows from all worksheets in the spreadsheet.
  /// Returns a list of [MeterReading] objects.
  Future<List<MeterReading>?> fetchAll() async {
    try {
      _log.fine('Fetching data from all worksheets');

      // Fetch the spreadsheet and the number of worksheets (years)
      final Spreadsheet spreadsheet = await _getSheet();
      final int noOfYears = spreadsheet.sheets.length;

      // Store data from all worksheets
      List<List<String>> result = [];

      for (int i = 0; i < noOfYears; i++) {
        // Fetch worksheet by index and retrieve its data
        final Worksheet? worksheet = spreadsheet.worksheetByIndex(i);

        if (worksheet != null) {
          List<List<String>> tmp = await _fetchWorksheet(worksheet);
          result.addAll(tmp);
        }
      }

      // Remove invalid or empty rows
      result.removeWhere((sublist) => sublist.isEmpty || sublist.every((element) => element.trim().isEmpty));

      // Convert rows into MeterReading objects
      List<MeterReading> meterReadings = MeterReadingLogic.fromListOfStringLists(result);

      return meterReadings;
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch all rows: $e', e, stackTrace);
      return null;
    }
  }

  /// Fetches the spreadsheet using the provided credentials and spreadsheet ID.
  Future<Spreadsheet> _getSheet({int credentialId = 0}) async {
    try {
      _log.fine('Fetching spreadsheet');
      final GSheets gsheets = GSheets(gsc.credentials[credentialId]);
      return await gsheets.spreadsheet(gsc.spreadsheetId);
    } catch (e, stackTrace) {
      _log.severe('Failed to get spreadsheet: $e', e, stackTrace);
      rethrow;
    }
  }

  /// Fetches a worksheet by its title (year).
  /// Creates a new worksheet if it does not exist.
  Future<Worksheet?> _getWorksheetByTitle(Spreadsheet spreadsheet, String year) async {
    try {
      _log.fine('Fetching worksheet: $year');

      // Try to find the worksheet by its title
      Worksheet? worksheetByTitle = spreadsheet.worksheetByTitle(year);

      // Create a new worksheet if it doesn't exist
      if (worksheetByTitle == null) {
        _log.fine('Worksheet $year not found. Creating new worksheet.');
        worksheetByTitle = await _createWorksheet(spreadsheet, year);
      }

      return worksheetByTitle;
    } catch (e, stackTrace) {
      _log.severe('Failed to get worksheet by title: $e', e, stackTrace);
      rethrow;
    }
  }

  /// Creates a new worksheet with the given [worksheetTitle].
  Future<Worksheet?> _createWorksheet(Spreadsheet spreadsheet, String worksheetTitle) async {
    try {
      _log.fine('Creating worksheet: $worksheetTitle');

      // Add a new worksheet to the spreadsheet
      Worksheet worksheetByTitle = await spreadsheet.addWorksheet(worksheetTitle);

      _log.fine('Worksheet $worksheetTitle created');
      return worksheetByTitle;
    } catch (e, stackTrace) {
      _log.severe('Failed to create worksheet: $e', e, stackTrace);
      rethrow;
    }
  }

  /// Fetches all rows from the given [worksheet].
  /// Returns a list of lists of strings, removing invalid rows.
  Future<List<List<String>>> _fetchWorksheet(Worksheet worksheet) async {
    try {
      _log.fine('Fetching data from worksheet: ${worksheet.title}');

      // Retrieve all rows from the worksheet
      List<List<String>> result = await worksheet.values.allRows();

      _log.fine('Raw data from worksheet: $result');

      // Remove invalid or empty rows
      result.removeWhere((sublist) => sublist.isEmpty || sublist.every((element) => element.trim().isEmpty));

      _log.fine('Cleaned data from worksheet: $result');
      return result;
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch data from worksheet: $e', e, stackTrace);
      rethrow;
    }
  }

  /// Returns the title of the worksheet corresponding to the year of the given [MeterReading].
  String _getWorksheetTitle(MeterReading reading) => reading.date.year.toString();

  Future<bool> _updateCredentialId({required int numberOfInserts, bool forceSwitch = false}) async {
    bool switched = false;
    bool isTimeToSwitch = (numberOfInserts % gsc.switchInterval) == 0;

    if (isTimeToSwitch || forceSwitch) {
      _log.fine('Switching credentials because switch limit');
      credentialId++;
      switched = true;
      await Future.delayed(const Duration(seconds: gsc.insertDelay));
    }

    if (credentialId > gsc.credentials.length) {
      credentialId = 1;
    }

    _log.fine('Switched Google Sheets credential ID to: $credentialId.');

    return switched;
  }
}
