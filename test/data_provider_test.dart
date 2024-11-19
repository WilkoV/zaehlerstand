import 'package:flutter_test/flutter_test.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:io';

import 'package:zaehlerstand/src/provider/data_provider.dart';

void main() {
  group('DataProvider Tests', () {
    late DataProvider dataProvider;

    setUp(() async {
      // Setup a temporary database for testing
      final tempDir = await Directory.systemTemp.createTemp();
      final dbPath = '${tempDir.path}/test_meter_readings.db';
      final db = sqlite3.open(dbPath);

      // Reinitialize the DatabaseHelper to use the test database
      DatabaseHelper.db = db;
      DatabaseHelper.createDb(db);

      // Initialize the DataProvider
      dataProvider = DataProvider();
    });

    tearDown(() async {
      // Clean up after each test
      final db = DatabaseHelper.db;
      db.execute('DELETE FROM meter_readings');
    });

    // Test: Fetch meter readings and verify the initial state
    test('Initial state should be empty', () async {
      // Verify initial state of dataProvider
      expect(dataProvider.meterReadings, isEmpty);
      expect(dataProvider.currentReading, isNull);
    });

    // Test: Fetch meter readings after adding data
    group('fetchMeterReadings', () {
      test('Fetch meter readings after adding data', () async {
        // Arrange: Add a meter reading
        final meterReading = MeterReading(
          date: DateTime(2023, 5, 12),
          reading: 150,
          isGenerated: false,
          enteredReading: 150,
        );
        await DatabaseHelper.insertMeterReading(meterReading);

        // Act: Fetch readings
        await dataProvider.fetchMeterReadings();

        // Assert: Check if the provider has the meter reading
        expect(dataProvider.meterReadings, isNotEmpty);
        expect(dataProvider.meterReadings.first.reading, equals(150));
      });
    });

    // Test: Fetch distinct years
    group('fetchDistinctYears', () {
      test('Fetch distinct years', () async {
        // Arrange: Add some readings
        final meterReading1 = MeterReading(date: DateTime(2023, 5, 12), reading: 150, isGenerated: false, enteredReading: 150);
        final meterReading2 = MeterReading(date: DateTime(2024, 5, 12), reading: 180, isGenerated: false, enteredReading: 180);
        await DatabaseHelper.insertMeterReading(meterReading1);
        await DatabaseHelper.insertMeterReading(meterReading2);

        // Act: Fetch distinct years
        final years = await dataProvider.fetchDistinctYears();

        // Assert: Verify the distinct years
        expect(years, containsAll([2023, 2024]));
      });
    });

    // Test: Fetch reading for a specific year
    group('fetchReadingForYear', () {
      test('Fetch reading for a specific year', () async {
        // Arrange: Add a reading for 2023
        final meterReading = MeterReading(date: DateTime(2023, 5, 12), reading: 150, isGenerated: false, enteredReading: 150);
        await DatabaseHelper.insertMeterReading(meterReading);

        // Act: Fetch reading for 2023
        final fetchedReading = await dataProvider.fetchReadingForYear(2023);

        // Assert: Verify the fetched reading
        expect(fetchedReading?.reading, equals(150));
        expect(fetchedReading?.date.year, equals(2023));
      });
    });

    // Test: Fetch reading for a specific number of days before
    group('fetchReadingDaysBefore', () {
      test('Fetch reading for a specific number of days before', () async {
        // Arrange: Add a reading for today
        var yesterday = DateTime.now().subtract(const Duration(days: 1));
        final todayReading = MeterReading(date: yesterday, reading: 200, isGenerated: false, enteredReading: 200);
        await DatabaseHelper.insertMeterReading(todayReading);

        // Act: Fetch reading 1 day before
        final fetchedReading = await dataProvider.fetchReadingDaysBefore(1);

        // Assert: Check if the fetched reading matches today's
        expect(fetchedReading?.reading, equals(200));
      });
    });

    // Test: Add new meter reading and refresh meter readings
    group('addMeterReading', () {
      test('Add new meter reading and refresh meter readings', () async {
        // Arrange: Create a meter reading to add
        final meterReading = MeterReading(date: DateTime(2023, 7, 5), reading: 220, isGenerated: false, enteredReading: 220);

        // Act: Add the reading and refresh the list
        await dataProvider.addMeterReading(meterReading);

        // Assert: Ensure the meter readings list contains the newly added reading
        expect(dataProvider.meterReadings, isNotEmpty);
        expect(dataProvider.meterReadings.first.reading, equals(220));
      });
    });

    // Test: Delete all meter readings
    group('deleteAllReadings', () {
      test('Delete all meter readings', () async {
        // Arrange: Add some readings
        final meterReading1 = MeterReading(date: DateTime(2023, 6, 10), reading: 250, isGenerated: false, enteredReading: 250);
        final meterReading2 = MeterReading(date: DateTime(2023, 7, 5), reading: 270, isGenerated: false, enteredReading: 270);
        await DatabaseHelper.insertMeterReading(meterReading1);
        await DatabaseHelper.insertMeterReading(meterReading2);

        // Act: Delete all readings and refresh the list
        await dataProvider.deleteAllReadings();

        // Assert: Ensure the readings list is empty after deletion
        expect(dataProvider.meterReadings, isEmpty);
      });
    });
  });
}
