import 'package:flutter_test/flutter_test.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

void main() {
  setUp(() async {
    await DatabaseHelper.deleteAllMeterReadings(); // Reset database before each test
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
        final reading = MeterReading(date: DateTime(2023, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);

        await DatabaseHelper.insertMeterReading(reading);

        final readings = await DatabaseHelper.getMeterReadings();
        expect(readings.length, 1);
        expect(readings.first.reading, 250);
      });

      test('should upsert meter readings correctly', () async {
        final initialReading = MeterReading(date: DateTime(2023, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final updatedReading = MeterReading(date: DateTime(2023, 5, 15), reading: 300, isGenerated: true, enteredReading: 300, isSynced: true);

        await DatabaseHelper.insertMeterReading(initialReading);
        await DatabaseHelper.insertMeterReading(updatedReading);

        final readings = await DatabaseHelper.getMeterReadings();
        expect(readings.length, 1);
        expect(readings.first.reading, 300);
      });
    });

    group('getMeterReadings', () {
      test('should fetch all readings', () async {
        final reading1 = MeterReading(date: DateTime(2023, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final reading2 = MeterReading(date: DateTime(2023, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

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
        final reading1 = MeterReading(date: DateTime(2023, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final reading2 = MeterReading(date: DateTime(2024, 5, 15), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        final years = await DatabaseHelper.getMeterReadingsDistinctYears();
        expect(years, [2023, 2024]);
      });

      test('should handle empty database gracefully', () async {
        final years = await DatabaseHelper.getMeterReadingsDistinctYears();
        expect(years.isEmpty, true);
      });
    });

    group('getReadingForYear', () {
      test('should fetch the first reading for a specific year', () async {
        final reading1 = MeterReading(date: DateTime(2023, 1, 1), reading: 100, isGenerated: false, enteredReading: 100, isSynced: false);
        final reading2 = MeterReading(date: DateTime(2023, 5, 15), reading: 200, isGenerated: false, enteredReading: 200, isSynced: false);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        final firstReading = await DatabaseHelper.getMeterReadingForYear(2023);
        expect(firstReading?.reading, 100);
      });

      test('should return null for a year with no readings', () async {
        final firstReading = await DatabaseHelper.getMeterReadingForYear(2023);
        expect(firstReading, isNull);
      });
    });

    group('getReadingDaysBefore', () {
      test('should fetch the reading for a specific number of days before today', () async {
        final now = DateTime.now();
        final reading = MeterReading(date: now.subtract(const Duration(days: 5)), reading: 150, isGenerated: false, enteredReading: 150, isSynced: false);

        await DatabaseHelper.insertMeterReading(reading);

        final fetchedReading = await DatabaseHelper.getMeterReadingDaysBefore(5);
        expect(fetchedReading?.reading, 150);
      });

      test('should return null for a date with no readings', () async {
        final fetchedReading = await DatabaseHelper.getMeterReadingDaysBefore(5);
        expect(fetchedReading, isNull);
      });
    });

    group('deleteAllReadings', () {
      test('should delete all readings', () async {
        final reading1 = MeterReading(date: DateTime(2023, 1, 1), reading: 100, isGenerated: false, enteredReading: 100, isSynced: false);
        final reading2 = MeterReading(date: DateTime(2023, 2, 1), reading: 200, isGenerated: false, enteredReading: 200, isSynced: false);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        await DatabaseHelper.deleteAllMeterReadings();

        final readings = await DatabaseHelper.getMeterReadings();
        expect(readings.isEmpty, true);
      });
    });

    group('bulkImport', () {
      test('should import multiple meter readings in bulk', () async {
        final readings = [
          MeterReading(date: DateTime(2023, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false),
          MeterReading(date: DateTime(2023, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false),
        ];

        await DatabaseHelper.bulkImport(readings);

        final fetchedReadings = await DatabaseHelper.getMeterReadings();
        expect(fetchedReadings.length, 2);

        expect(fetchedReadings[0].reading, 250);
        expect(fetchedReadings[1].reading, 300);
      });

      test('should handle upserts during bulk import', () async {
        final initialReadings = [
          MeterReading(date: DateTime(2023, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false),
          MeterReading(date: DateTime(2023, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false),
        ];

        final updatedReadings = [
          MeterReading(date: DateTime(2023, 5, 15), reading: 350, isGenerated: false, enteredReading: 350, isSynced: false),
          MeterReading(date: DateTime(2023, 6, 10), reading: 400, isGenerated: false, enteredReading: 400, isSynced: false),
        ];

        await DatabaseHelper.bulkImport(initialReadings);
        await DatabaseHelper.bulkImport(updatedReadings);

        final fetchedReadings = await DatabaseHelper.getMeterReadings();
        expect(fetchedReadings.length, 2);

        expect(fetchedReadings[0].reading, 350);
        expect(fetchedReadings[1].reading, 400);
      });

      test('should handle an empty list gracefully', () async {
        await DatabaseHelper.bulkImport([]);

        final fetchedReadings = await DatabaseHelper.getMeterReadings();
        expect(fetchedReadings.isEmpty, true);
      });
    });

    group('countMeterReadings', () {
      test('should return 0 when no meter readings exist', () async {
        final count = await DatabaseHelper.countMeterReadings();
        expect(count, 0);
      });

      test('should return the correct count after inserting readings', () async {
        final reading1 = MeterReading(date: DateTime(2023, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final reading2 = MeterReading(date: DateTime(2023, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        final count = await DatabaseHelper.countMeterReadings();
        expect(count, 2);
      });

      test('should return the correct count after deleting all readings', () async {
        final reading1 = MeterReading(date: DateTime(2023, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final reading2 = MeterReading(date: DateTime(2023, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

        await DatabaseHelper.insertMeterReading(reading1);
        await DatabaseHelper.insertMeterReading(reading2);

        await DatabaseHelper.deleteAllMeterReadings();

        final count = await DatabaseHelper.countMeterReadings();
        expect(count, 0);
      });
    });
  });
}
