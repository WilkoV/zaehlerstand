import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

class DataProvider extends ChangeNotifier {
  static final _log = Logger('DataProvider');

  List<MeterReading> _meterReadings = [];
  MeterReading? _currentReading;

  List<MeterReading> get meterReadings => _meterReadings;
  MeterReading? get currentReading => _currentReading;

  static Future<DataProvider> create() async {
    await DatabaseHelper.database;

    _log.fine('DataProvider created');

    return DataProvider();
  }

  Future<void> fetchMeterReadings() async {
    _log.fine('Fetching meter readings');

    _meterReadings = await DatabaseHelper.getMeterReadings();
    _log.fine('Fetched ${_meterReadings.length} meter readings');

    notifyListeners();
  }

  Future<List<int>> fetchDistinctYears() async {
    _log.fine('Fetching distinct years');

    final years = await DatabaseHelper.getMeterReadingsDistinctYears();
    _log.fine('Fetched ${years.length} distinct years: $years');

    return years;
  }

  Future<MeterReading?> fetchReadingForYear(int year) async {
    _log.fine('Fetching reading for year $year');

    _currentReading = await DatabaseHelper.getMeterReadingForYear(year);
    _log.fine('Fetched reading: $_currentReading');

    notifyListeners();
    return _currentReading;
  }

  Future<MeterReading?> fetchReadingDaysBefore(int daysBefore) async {
    _log.fine('Fetching reading $daysBefore days before');

    _currentReading = await DatabaseHelper.getMeterReadingDaysBefore(daysBefore);
    _log.fine('Fetched reading: $_currentReading');

    notifyListeners();
    return _currentReading;
  }

  Future<void> addMeterReading(MeterReading reading) async {
    _log.fine('Adding meter reading: $reading');

    await DatabaseHelper.insertMeterReading(reading);
    await fetchMeterReadings(); // Refresh the list
  }

  Future<void> deleteAllReadings() async {
    _log.fine('Deleting all meter readings');

    await DatabaseHelper.deleteAllMeterReadings();
    await fetchMeterReadings(); // Refresh the list
  }

  Future<void> bulkImportMeterReadings(List<MeterReading> readings) async {
    _log.fine('Bulk importing ${readings.length} meter readings');

    await DatabaseHelper.bulkImport(readings);
    await fetchMeterReadings(); // Refresh the list

    _log.fine('Bulk import completed');
  }
}
