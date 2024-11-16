import 'package:freezed_annotation/freezed_annotation.dart';

part 'meter_reading.freezed.dart';
part 'meter_reading.g.dart';

@freezed
class MeterReading with _$MeterReading {
  factory MeterReading({
    required DateTime date,
    required int reading,
  }) = _MeterReading;

  factory MeterReading.fromJson(Map<String, dynamic> json) => _$MeterReadingFromJson(json);
}