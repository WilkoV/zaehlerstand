import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaehlerstand/src/io/database/database_helper.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';

void main() {
  group('DataProvider Tests', () {
    late DataProvider dataProvider;

    setUp(() async {
      // Setup an in-memory database for testing
      final db = sqlite3.openInMemory();

      // Reinitialize the DatabaseHelper to use the test database
      DatabaseHelper.db = db;
      DatabaseHelper.createDb(db);

      await DatabaseHelper.deleteAllMeterReadings();

      // Initialize the DataProvider
      dataProvider = DataProvider();
    });

    tearDown(() async {
      // Clean up after each test
      final db = DatabaseHelper.db;
      db.execute('DELETE FROM meter_readings');
    });

    // Test: Fetch meter readings after adding data
    group('fetchMeterReadings', () {
      test('Fetch meter readings after adding data', () async {
        // Arrange: Add a meter reading
        final meterReading = MeterReading(
          date: DateTime(2022, 5, 12),
          reading: 150,
          isGenerated: false,
          enteredReading: 150,
          isSynced: false,
        );
        await DatabaseHelper.insertMeterReading(meterReading);

        // Act: Fetch readings
        await dataProvider.getAllMeterReadings();

        // Assert: Check if the provider has the meter reading
        expect(dataProvider.meterReadings, isNotEmpty);
        expect(dataProvider.meterReadings.first.reading, equals(150));
      });
    });

    // Test: Fetch distinct years
    group('fetchDistinctYears', () {
      test('Fetch distinct years', () async {
        // Arrange: Add some readings
        final meterReading1 = MeterReading(date: DateTime(2022, 5, 12), reading: 150, isGenerated: false, enteredReading: 150, isSynced: false);
        final meterReading2 = MeterReading(date: DateTime(2024, 5, 12), reading: 180, isGenerated: false, enteredReading: 180, isSynced: false);
        await DatabaseHelper.insertMeterReading(meterReading1);
        await DatabaseHelper.insertMeterReading(meterReading2);

        // Act: Fetch distinct years
        await dataProvider.getDataYears();
        

        // Assert: Verify the distinct years
        expect(dataProvider.dataYears, containsAll([2022, 2024]));
      });
    });

    // Test: Add new meter reading and refresh meter readings
    group('addMeterReading', () {
      test('Add new meter reading and refresh meter readings', () async {
        // Act: Add the reading and refresh the list
        await dataProvider.addMeterReading(220);

        // Assert: Ensure the meter readings list contains the newly added reading
        expect(dataProvider.meterReadings, isNotEmpty);
        expect(dataProvider.meterReadings.first.reading, equals(220));
      });
    });

    // Test: Delete all meter readings
    group('deleteAllReadings', () {
      test('Delete all meter readings', () async {
        // Arrange: Add some readings
        final meterReading1 = MeterReading(date: DateTime(2022, 6, 10), reading: 250, isGenerated: false, enteredReading: 250, isSynced: false);
        final meterReading2 = MeterReading(date: DateTime(2022, 7, 5), reading: 270, isGenerated: false, enteredReading: 270, isSynced: false);
        await DatabaseHelper.insertMeterReading(meterReading1);
        await DatabaseHelper.insertMeterReading(meterReading2);

        // Act: Delete all readings and refresh the list
        await dataProvider.deleteAllMeterReadings();

        // Assert: Ensure the readings list is empty after deletion
        expect(dataProvider.meterReadings, isEmpty);
      });
    });
  });
}
