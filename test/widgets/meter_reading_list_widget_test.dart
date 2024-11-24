import 'package:flutter_test/flutter_test.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/widgets/data_view/meter_reading_list_widget.dart';

void main() {
  group('calculateDailyConsumption', () {
    final List<MeterReading> meterReadings = [
      MeterReading(
        date: DateTime(2023, 1, 1),
        enteredReading: 100,
        reading: 100,
        isGenerated: false,
        isSynced: true,
      ),
      MeterReading(
        date: DateTime(2023, 1, 2),
        enteredReading: 200,
        reading: 200,
        isGenerated: false,
        isSynced: true,
      ),
      MeterReading(
        date: DateTime(2023, 1, 3),
        enteredReading: 300,
        reading: 300,
        isGenerated: true,
        isSynced: false,
      ),
    ];

    final widget = MeterReadingListWidget(meterReadings: meterReadings, year: 2023);

    test('calculates difference with the next reading when index < filteredReadings.length - 1', () {
      final reading = meterReadings[1]; // Jan 2
      final filteredReadings = meterReadings.reversed.toList();

      final result = widget.calculateDailyConsumption(reading, 1, filteredReadings);
      expect(result, 'Tagesverbrauch: 100'); // Difference between 200 (Jan 2) and 300 (Jan 3)
    });

    test('calculates difference with a previous day reading when index == filteredReadings.length - 1', () {
      final reading = meterReadings.last; // Jan 3
      final filteredReadings = meterReadings.reversed.toList();

      final result = widget.calculateDailyConsumption(reading, 2, filteredReadings);
      expect(result, 'Tagesverbrauch: 100'); // Difference between 300 (Jan 3) and 200 (Jan 2)
    });

    test('falls back to current reading when no previous day reading exists', () {
      final reading = MeterReading(
        date: DateTime(2023, 1, 5),
        enteredReading: 500,
        reading: 500,
        isGenerated: true,
        isSynced: false,
      );

      final result = widget.calculateDailyConsumption(reading, 0, [reading]);
      expect(result, 'Tagesverbrauch: 0'); // No previous reading exists, fallback to 0
    });

    test('handles empty filteredReadings gracefully', () {
      final result = widget.calculateDailyConsumption(
        meterReadings.first, // Jan 1
        0,
        [],
      );
      expect(result, 'Tagesverbrauch: 0'); // No readings available
    });

    test('handles single reading in filteredReadings gracefully', () {
      final singleReading = MeterReading(
        date: DateTime(2023, 1, 1),
        enteredReading: 100,
        reading: 100,
        isGenerated: false,
        isSynced: true,
      );

      final result = widget.calculateDailyConsumption(singleReading, 0, [singleReading]);
      expect(result, 'Tagesverbrauch: 0'); // Only one reading
    });
  });
}
