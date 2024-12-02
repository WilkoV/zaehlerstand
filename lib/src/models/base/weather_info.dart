import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_info.freezed.dart';
part 'weather_info.g.dart';

@freezed
class WeatherInfo with _$WeatherInfo {
  factory WeatherInfo({
    required DateTime date,
    required double temperature,
    required double feelsLikeTemperature,
    required double windSpeed,
    required String icon,
    required bool isGenerated,
  }) = _WeatherInfo;

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => _$WeatherInfoFromJson(json);
}
