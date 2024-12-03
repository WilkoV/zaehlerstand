import 'package:flutter_test/flutter_test.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';

void main() {
  group('Reading', () {
    test('should create a Reading instance with correct values', () {
      final date = DateTime(2023, 11, 16);
      const reading = 123;
      const isGenerate = false;
      const enteredReading = 123;

      final result = Reading(date: date, reading: reading, isGenerated: isGenerate, enteredReading: enteredReading, isSynced: false);

      expect(result.date, date);
      expect(result.reading, reading);
    });

    test('should convert Reading to JSON correctly', () {
      final date = DateTime(2023, 11, 16);
      const reading = 123;
      const isGenerate = false;
      const enteredReading = 123;

      final result = Reading(date: date, reading: reading, isGenerated: isGenerate, enteredReading: enteredReading, isSynced: false);
      final json = result.toJson();

      expect(json, {
        'date': date.toIso8601String(),
        'reading': reading,
        'isGenerated': false,
        'enteredReading': 123,
        'isSynced': false
      });
    });

    test('should create a Reading from JSON correctly', () {
      final json = {
        'date': '2023-11-16T00:00:00.000',
        'reading': 123,
        'isGenerated': false,
        'enteredReading': 123,
        'isSynced': false
      };

      final result = Reading.fromJson(json);

      expect(result.date, DateTime.parse(json['date'] as String));
      expect(result.reading, json['reading']);
    });

    test('should compare two Reading instances correctly', () {
      final date = DateTime(2023, 11, 16);
      const reading = 123;
      const isGenerate = false;
      const enteredReading = 123;

      final reading1 = Reading(date: date, reading: reading, isGenerated: isGenerate, enteredReading: enteredReading, isSynced: false);
      final reading2 = Reading(date: date, reading: reading, isGenerated: isGenerate, enteredReading: enteredReading, isSynced: false);

      expect(reading1, reading2);
    });
  });
}
