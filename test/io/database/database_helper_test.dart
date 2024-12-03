import 'package:flutter_test/flutter_test.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';

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

    group('insertReading', () {
      test('should insert a new meter reading', () async {
        final reading = Reading(date: DateTime(2022, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);

        await DatabaseHelper.insertReading(reading);

        final readings = await DatabaseHelper.getAllReadings();
        expect(readings.length, 1);
        expect(readings.first.reading, 250);
      });

      test('should upsert meter readings correctly', () async {
        final initialReading = Reading(date: DateTime(2022, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final updatedReading = Reading(date: DateTime(2022, 5, 15), reading: 300, isGenerated: true, enteredReading: 300, isSynced: true);

        await DatabaseHelper.insertReading(initialReading);
        await DatabaseHelper.insertReading(updatedReading);

        final readings = await DatabaseHelper.getAllReadings();
        expect(readings.length, 1);
        expect(readings.first.reading, 300);
      });
    });

    group('getReadings', () {
      test('should fetch all readings', () async {
        final reading1 = Reading(date: DateTime(2022, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final reading2 = Reading(date: DateTime(2022, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

        await DatabaseHelper.insertReading(reading1);
        await DatabaseHelper.insertReading(reading2);

        final readings = await DatabaseHelper.getAllReadings();
        expect(readings.length, 2);
      });

      test('should handle empty database gracefully', () async {
        final readings = await DatabaseHelper.getAllReadings();
        expect(readings.isEmpty, true);
      });
    });

    group('getDistinctYears', () {
      test('should fetch distinct years', () async {
        final reading1 = Reading(date: DateTime(2022, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final reading2 = Reading(date: DateTime(2024, 5, 15), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

        await DatabaseHelper.insertReading(reading1);
        await DatabaseHelper.insertReading(reading2);

        final years = await DatabaseHelper.getReadingsDistinctYears();
        expect(years, [2024, 2022]);
      });

      test('should handle empty database gracefully', () async {
        final years = await DatabaseHelper.getReadingsDistinctYears();
        expect(years.isEmpty, true);
      });
    });

    group('getReadingsForYear', () {
      test('should fetch the first reading for a specific year', () async {
        final reading1 = Reading(date: DateTime(2022, 1, 1), reading: 100, isGenerated: false, enteredReading: 100, isSynced: false);
        final reading2 = Reading(date: DateTime(2022, 5, 15), reading: 200, isGenerated: false, enteredReading: 200, isSynced: false);
        final reading3 = Reading(date: DateTime(2021, 5, 15), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

        await DatabaseHelper.insertReading(reading1);
        await DatabaseHelper.insertReading(reading2);
        await DatabaseHelper.insertReading(reading3);

        final readings = await DatabaseHelper.getReadingForYear(2022);
        expect(readings.length, 2);
      });

      test('should return null for a year with no readings', () async {
        final firstReading = await DatabaseHelper.getReadingForYear(2020);
        expect(firstReading, isEmpty);
      });
    });

    group('getReadingDaysBefore', () {
      test('should fetch the reading for a specific number of days before today', () async {
        final now = DateTime.now();
        final reading = Reading(date: now.subtract(const Duration(days: 5)), reading: 150, isGenerated: false, enteredReading: 150, isSynced: false);

        await DatabaseHelper.insertReading(reading);

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
        final reading1 = Reading(date: DateTime(2022, 1, 1), reading: 100, isGenerated: false, enteredReading: 100, isSynced: false);
        final reading2 = Reading(date: DateTime(2022, 2, 1), reading: 200, isGenerated: false, enteredReading: 200, isSynced: false);

        await DatabaseHelper.insertReading(reading1);
        await DatabaseHelper.insertReading(reading2);

        await DatabaseHelper.deleteAllReadings();

        final readings = await DatabaseHelper.getAllReadings();
        expect(readings.isEmpty, true);
      });
    });

    group('bulkImport', () {
      test('should import multiple meter readings in bulk', () async {
        final readings = [
          Reading(date: DateTime(2022, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false),
          Reading(date: DateTime(2022, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false),
        ];

        await DatabaseHelper.bulkInsert(readings);

        final fetchedReadings = await DatabaseHelper.getAllReadings();
        expect(fetchedReadings.length, 2);

        expect(fetchedReadings[0].reading, 300);
        expect(fetchedReadings[1].reading, 250);
      });

      test('should handle upserts during bulk import', () async {
        final initialReadings = [
          Reading(date: DateTime(2022, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false),
          Reading(date: DateTime(2022, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false),
        ];

        final updatedReadings = [
          Reading(date: DateTime(2022, 5, 15), reading: 350, isGenerated: false, enteredReading: 350, isSynced: false),
          Reading(date: DateTime(2022, 6, 10), reading: 400, isGenerated: false, enteredReading: 400, isSynced: false),
        ];

        await DatabaseHelper.bulkInsert(initialReadings);
        await DatabaseHelper.bulkInsert(updatedReadings);

        final fetchedReadings = await DatabaseHelper.getAllReadings();
        expect(fetchedReadings.length, 2);

        expect(fetchedReadings[0].reading, 400);
        expect(fetchedReadings[1].reading, 350);
      });

      test('should handle an empty list gracefully', () async {
        await DatabaseHelper.bulkInsert([]);

        final fetchedReadings = await DatabaseHelper.getAllReadings();
        expect(fetchedReadings.isEmpty, true);
      });
    });

    group('countReadings', () {
      test('should return 0 when no meter readings exist', () async {
        final count = await DatabaseHelper.countReadings();
        expect(count, 0);
      });

      test('should return the correct count after inserting readings', () async {
        final reading1 = Reading(date: DateTime(2022, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final reading2 = Reading(date: DateTime(2022, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

        await DatabaseHelper.insertReading(reading1);
        await DatabaseHelper.insertReading(reading2);

        final count = await DatabaseHelper.countReadings();
        expect(count, 2);
      });

      test('should return the correct count after deleting all readings', () async {
        final reading1 = Reading(date: DateTime(2022, 5, 15), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final reading2 = Reading(date: DateTime(2022, 6, 10), reading: 300, isGenerated: false, enteredReading: 300, isSynced: false);

        await DatabaseHelper.insertReading(reading1);
        await DatabaseHelper.insertReading(reading2);

        await DatabaseHelper.deleteAllReadings();

        final count = await DatabaseHelper.countReadings();
        expect(count, 0);
      });
    });
  });
}
