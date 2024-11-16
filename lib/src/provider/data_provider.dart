import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';

class DataProvider extends ChangeNotifier {
  List<MeterReading> _meterReadings = [];
  MeterReading? _currentReading;

  List<MeterReading> get meterReadings => _meterReadings;
  MeterReading? get currentReading => _currentReading;

  // Fetch all meter readings from the database
  Future<void> fetchMeterReadings() async {
    _meterReadings = await DatabaseHelper.getMeterReadings();
    notifyListeners();
  }

  // Fetch distinct years
  Future<List<int>> fetchDistinctYears() async {
    return await DatabaseHelper.getMeterReadingsDistinctYears();
  }

  // Fetch the first reading for a specific year
  Future<MeterReading?> fetchReadingForYear(int year) async {
    _currentReading = await DatabaseHelper.getMeterReadingForYear(year);
    notifyListeners();
    return _currentReading;
  }

  // Fetch the reading for a specific number of days before the current date
  Future<MeterReading?> fetchReadingDaysBefore(int daysBefore) async {
    _currentReading = await DatabaseHelper.getMeterReadingDaysBefore(daysBefore);
    notifyListeners();
    return _currentReading;
  }

  // Insert a new meter reading into the database
  Future<void> addMeterReading(MeterReading reading) async {
    await DatabaseHelper.insertMeterReading(reading);
    await fetchMeterReadings(); // Refresh the list
  }

  // Delete all readings
  Future<void> deleteAllReadings() async {
    await DatabaseHelper.deleteAllMeterReadings();
    await fetchMeterReadings(); // Refresh the list
  }
}
