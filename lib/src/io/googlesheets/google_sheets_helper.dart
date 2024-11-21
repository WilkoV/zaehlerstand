import 'package:gsheets/gsheets.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/constants/google_sheets_credentials.dart' as gsc;
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/models/logic/meter_reading_logic.dart';

class GoogleSheetsHelper {
  final Logger _log = Logger('GoogleSheetsHelper');

  // TODO: Get total count
  // TODO: Get last entry by date

  Future<bool> insertRow(MeterReading reading) async {
    try {
      final Spreadsheet spreadsheet = await _getSheet();
      final Worksheet? worksheet = await _getWorksheetByTitle(spreadsheet, _getWorksheetTitle(reading));

      if (worksheet == null) {
        _log.warning('Worksheet is null, cannot insert row.');
        return false;
      }
      final bool ok = await worksheet.values.insertRow(reading.getDayOfYear(), reading.toDynamicList());
      return ok;
    } catch (e, stackTrace) {
      _log.severe('Failed to insert row: $e', e, stackTrace);
      return false;
    }
  }

  Future<List<MeterReading>?> fetchYear(String year) async {
    try {
      _log.fine('Getting data of a year');

      final Spreadsheet spreadsheet = await _getSheet();
      final Worksheet? worksheet = await _getWorksheetByTitle(spreadsheet, year);

      if (worksheet == null) {
        _log.warning('Worksheet is null, cannot fetch rows.');
        return null;
      }

      List<List<String>> result = await _fetchWorksheet(worksheet);

      List<MeterReading> meterReadings = [];
      for (var row in result) {
        try {
          meterReadings.add(MeterReadingLogic.fromList(row));
        } catch (e) {
          _log.warning('Failed to create MeterReading from row: $row', e);
        }
      }

      _log.fine('Fetched rows: ${result.toString()}');
      return meterReadings;
    } catch (e, stackTrace) {
      _log.severe("Failed to fetch year's rows: $e", e, stackTrace);
      return null;
    }
  }

  Future<List<MeterReading>?> fetchAll() async {
    try {
      _log.fine('Getting all data');

      final Spreadsheet spreadsheet = await _getSheet();
      final int noOfYears = spreadsheet.sheets.length;

      List<List<String>>? result = [<String>[]];

      for (int i = 0; i < noOfYears; i++) {
        final Worksheet? worksheet = spreadsheet.worksheetByIndex(i);

        List<List<String>>? tmp = await _fetchWorksheet(worksheet!);

        result.addAll(tmp);

        await Future.delayed(const Duration(seconds: 2));
      }

      result.removeWhere((sublist) => sublist.isEmpty || sublist.every((element) => element.trim().isEmpty));

      List<MeterReading> meterReadings = [];
      for (var row in result) {
        try {
          meterReadings.add(MeterReadingLogic.fromList(row));
        } catch (e) {
          _log.warning('Failed to create MeterReading from row: $row', e);
        }
      }

      return meterReadings;
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch all rows: $e', e, stackTrace);
      return null;
    }
  }

  Future<Spreadsheet> _getSheet() async {
    try {
      _log.fine('Fetching spreadsheet.');
      final GSheets gsheets = GSheets(gsc.credentials);
      return await gsheets.spreadsheet(gsc.spreadsheetId);
    } catch (e, stackTrace) {
      _log.severe('Failed to get sheet: $e', e, stackTrace);
      rethrow;
    }
  }

  Future<Worksheet?> _getWorksheetByTitle(Spreadsheet spreadsheet, String year) async {
    try {
      _log.fine('Fetching worksheet.');

      Worksheet? worksheetByTitle = spreadsheet.worksheetByTitle(year);

      if (worksheetByTitle == null) {
        _log.fine('Worksheet $year not found.');

        worksheetByTitle = await _createWorksheet(spreadsheet, year);
      }

      return worksheetByTitle;
    } catch (e, stackTrace) {
      _log.severe('Failed to get worksheet by title: $e', e, stackTrace);
      rethrow;
    }
  }

  Future<Worksheet?> _createWorksheet(Spreadsheet spreadsheet, String worksheetTitle) async {
    try {
      _log.fine('Creating worksheet $worksheetTitle');

      Worksheet worksheetByTitle = await spreadsheet.addWorksheet(worksheetTitle);
      _log.fine('Worksheet $worksheetTitle created');

      return worksheetByTitle;
    } on Exception catch (e, stackTrace) {
      _log.severe('Failed to create spreadsheet: $e', e, stackTrace);
      rethrow;
    }
  }

  Future<List<List<String>>> _fetchWorksheet(Worksheet worksheet) async {
    try {
      _log.fine('Fetching data from sheet ${worksheet.title}');

      List<List<String>> result = await worksheet.values.allRows();

      _log.fine('Dirty data from sheet: $result');

      result.removeWhere((sublist) => sublist.isEmpty || sublist.every((element) => element.trim().isEmpty));

      _log.fine('Trimmed data from sheet: $result');

      return result;
    } on Exception catch (e, stackTrace) {
      _log.severe('Failed to fetch data from worksheet: $e', e, stackTrace);
      rethrow;
    }
  }

  String _getWorksheetTitle(MeterReading reading) => reading.date.year.toString();
}
