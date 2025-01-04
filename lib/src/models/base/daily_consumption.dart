import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_consumption.freezed.dart';

@freezed
class DailyConsumption with _$DailyConsumption {
  factory DailyConsumption({
    required DateTime date,
    required int consumption,
    double? minTemperature,
    double? maxTemperature,
    double? minFeelsLike,
    double? maxFeelsLike,
  }) = _DailyConsumption;
}
