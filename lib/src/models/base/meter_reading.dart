import 'package:freezed_annotation/freezed_annotation.dart';

part 'meter_reading.freezed.dart';
part 'meter_reading.g.dart';

@freezed
class MeterReading with _$MeterReading {
  factory MeterReading({
    required DateTime date,
    required int enteredReading,
    required int reading,
    required bool isGenerated,
    required bool isSynced,
  }) = _MeterReading;

  factory MeterReading.fromJson(Map<String, dynamic> json) => _$MeterReadingFromJson(json);
  factory MeterReading.fromInput(int enteredReading) => MeterReading(
        date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
        enteredReading: enteredReading,
        reading: enteredReading,
        isGenerated: false,
        isSynced: false,
      );

  factory MeterReading.fromGenerateData(DateTime targetDate, int calculatedReading) => MeterReading(
        date: DateTime(targetDate.year, targetDate.month, targetDate.day, 12),
        enteredReading: 0,
        reading: calculatedReading,
        isGenerated: true,
        isSynced: false,
      );
}
