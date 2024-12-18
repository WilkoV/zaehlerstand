import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_info.freezed.dart';
part 'weather_info.g.dart';

@freezed
class WeatherInfo with _$WeatherInfo {
  factory WeatherInfo({
    required DateTime date,
    required double temperature,
    required bool isGenerated,
  }) = _WeatherInfo;

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => _$WeatherInfoFromJson(json);

  factory WeatherInfo.fromInput(DateTime temperatureDate, double temperature) => WeatherInfo(
        date: DateTime(temperatureDate.year, temperatureDate.month, temperatureDate.day, 12),
        temperature: temperature,
        isGenerated: false,
      );

  factory WeatherInfo.fromGenerateData(DateTime targetDate, double calculatedTemperature) => WeatherInfo(
        date: targetDate,
        temperature: calculatedTemperature,
        isGenerated: true,
      );
}
