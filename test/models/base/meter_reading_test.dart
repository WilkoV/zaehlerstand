import 'package:flutter_test/flutter_test.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

void main() {
  group('MeterReading', () {
    test('should create a MeterReading instance with correct values', () {
      final date = DateTime(2023, 11, 16);
      const reading = 123;
      const isGenerate = false;
      const enteredReading = 123;

      final meterReading = MeterReading(date: date, reading: reading, isGenerated: isGenerate, enteredReading: enteredReading, isSynced: false);

      expect(meterReading.date, date);
      expect(meterReading.reading, reading);
    });

    test('should convert MeterReading to JSON correctly', () {
      final date = DateTime(2023, 11, 16);
      const reading = 123;
      const isGenerate = false;
      const enteredReading = 123;

      final meterReading = MeterReading(date: date, reading: reading, isGenerated: isGenerate, enteredReading: enteredReading, isSynced: false);
      final json = meterReading.toJson();

      expect(json, {
        'date': date.toIso8601String(),
        'reading': reading,
        'isGenerated': false,
        'enteredReading': 123,
        'isSynced': false
      });
    });

    test('should create a MeterReading from JSON correctly', () {
      final json = {
        'date': '2023-11-16T00:00:00.000',
        'reading': 123,
        'isGenerated': false,
        'enteredReading': 123,
        'isSynced': false
      };

      final meterReading = MeterReading.fromJson(json);

      expect(meterReading.date, DateTime.parse(json['date'] as String));
      expect(meterReading.reading, json['reading']);
    });

    test('should compare two MeterReading instances correctly', () {
      final date = DateTime(2023, 11, 16);
      const reading = 123;
      const isGenerate = false;
      const enteredReading = 123;

      final meterReading1 = MeterReading(date: date, reading: reading, isGenerated: isGenerate, enteredReading: enteredReading, isSynced: false);
      final meterReading2 = MeterReading(date: date, reading: reading, isGenerated: isGenerate, enteredReading: enteredReading, isSynced: false);

      expect(meterReading1, meterReading2);
    });
  });
}
