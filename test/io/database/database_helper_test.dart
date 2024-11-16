import 'package:flutter_test/flutter_test.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

void main() {
  setUp(() async {
    await DatabaseHelper.deleteAllReadings(); // Reset database before each test
  });

  group('DatabaseHelper Tests', () {
    group('Singleton and Initialization', () {
      test('should initialize database and ensure singleton access', () async {
        final db1 = await DatabaseHelper.database;
        final db2 = await DatabaseHelper.database;

        expect(db1, db2); // Singleton access should return the same instance
      });
    });

    group('insertMeterReading', () {
      test('should insert a new meter reading', () async {
        final reading = MeterReading(date: DateTime(2023, 5, 15), reading: 250);

        await DatabaseHelper.insertMeterReading(reading);

        final readings = await DatabaseHelper.getMeterReadings();
        expect(readings.length, 1);
        expect(readings.first.reading, 250);
      });

      test('should upsert meter readings correctly', () async {
        final initialReading = MeterReading(date: DateTime(2023, 5, 15), reading: 250);
        final updatedReading = MeterReading(date: DateTime(2023, 5, 15), reading: 300);

        await DatabaseHelper.insertMeterReading(initialReading);
        await DatabaseHelper.insertMeterReading(updatedReading);

        final readings = await DatabaseHelper.getMeterReadings();
        expect(readings.length, 1);
        expect(readings.first.reading, 300);
      });
    });

    group('getMeterReadings', () {
      test('should fetch all readings', () async {
        final reading1 = MeterReading(date: DateTime(2023, 5, 15), reading: 250);
        final reading2 = MeterReading(date: DateTime(2023, 6, 10), reading: 300);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        final readings = await DatabaseHelper.getMeterReadings();
        expect(readings.length, 2);
      });

      test('should handle empty database gracefully', () async {
        final readings = await DatabaseHelper.getMeterReadings();
        expect(readings.isEmpty, true);
      });
    });

    group('getDistinctYears', () {
      test('should fetch distinct years', () async {
        final reading1 = MeterReading(date: DateTime(2023, 5, 15), reading: 250);
        final reading2 = MeterReading(date: DateTime(2024, 5, 15), reading: 300);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        final years = await DatabaseHelper.getDistinctYears();
        expect(years, [2023, 2024]);
      });

      test('should handle empty database gracefully', () async {
        final years = await DatabaseHelper.getDistinctYears();
        expect(years.isEmpty, true);
      });
    });

    group('getReadingForYear', () {
      test('should fetch the first reading for a specific year', () async {
        final reading1 = MeterReading(date: DateTime(2023, 1, 1), reading: 100);
        final reading2 = MeterReading(date: DateTime(2023, 5, 15), reading: 200);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        final firstReading = await DatabaseHelper.getReadingForYear(2023);
        expect(firstReading?.reading, 100);
      });

      test('should return null for a year with no readings', () async {
        final firstReading = await DatabaseHelper.getReadingForYear(2023);
        expect(firstReading, isNull);
      });
    });

    group('getReadingDaysBefore', () {
      test('should fetch the reading for a specific number of days before today', () async {
        final now = DateTime.now();
        final reading = MeterReading(date: now.subtract(const Duration(days: 5)), reading: 150);

        await DatabaseHelper.insertMeterReading(reading);

        final fetchedReading = await DatabaseHelper.getReadingDaysBefore(5);
        expect(fetchedReading?.reading, 150);
      });

      test('should return null for a date with no readings', () async {
        final fetchedReading = await DatabaseHelper.getReadingDaysBefore(5);
        expect(fetchedReading, isNull);
      });
    });

    group('deleteAllReadings', () {
      test('should delete all readings', () async {
        final reading1 = MeterReading(date: DateTime(2023, 1, 1), reading: 100);
        final reading2 = MeterReading(date: DateTime(2023, 2, 1), reading: 200);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        await DatabaseHelper.deleteAllReadings();

        final readings = await DatabaseHelper.getMeterReadings();
        expect(readings.isEmpty, true);
      });
    });
  });
}
