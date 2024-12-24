import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading.freezed.dart';
part 'reading.g.dart';

@freezed
class Reading with _$Reading {
  factory Reading({
    required DateTime date,
    required int enteredReading,
    required int reading,
    required bool isGenerated,
    required bool isSynced,
  }) = _Reading;

  factory Reading.fromJson(Map<String, dynamic> json) => _$ReadingFromJson(json);

  factory Reading.fromInput(int enteredReading) => Reading(
        date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
        enteredReading: enteredReading,
        reading: enteredReading,
        isGenerated: false,
        isSynced: false,
      );

  factory Reading.fromGenerateData(DateTime targetDate, int calculatedReading) => Reading(
        date: DateTime(targetDate.year, targetDate.month, targetDate.day, 12),
        enteredReading: 0,
        reading: calculatedReading,
        isGenerated: true,
        isSynced: false,
      );
}
