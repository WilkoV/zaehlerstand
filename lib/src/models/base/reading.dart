import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zaehlerstand/src/models/base/weather_info.dart';

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
    required WeatherInfo weatherInfo,
  }) = _Reading;

  factory Reading.fromJson(Map<String, dynamic> json) => _$ReadingFromJson(json);
  
  factory Reading.fromInput(int enteredReading, DateTime temperatureDate, double temperature) => Reading(
        date: DateTime(temperatureDate.year, temperatureDate.month, temperatureDate.day, 12),
        enteredReading: enteredReading,
        reading: enteredReading,
        isGenerated: false,
        isSynced: false,
        weatherInfo: WeatherInfo.fromInput(temperatureDate, temperature),
      );

  factory Reading.fromGenerateData(DateTime targetDate, int calculatedReading, double calculatedTemperature) => Reading(
        date: DateTime(targetDate.year, targetDate.month, targetDate.day, 12),
        enteredReading: 0,
        reading: calculatedReading,
        isGenerated: true,
        isSynced: false,
        weatherInfo: WeatherInfo.fromGenerateData(targetDate, calculatedTemperature)
      );
}
