import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_consumption.freezed.dart';
part 'daily_consumption.g.dart';

@freezed
class DailyConsumption with _$DailyConsumption {
  factory DailyConsumption({
    required DateTime date,
    required int value,
  }) = _DailyConsumption;

  factory DailyConsumption.fromJson(Map<String, dynamic> json) => _$DailyConsumptionFromJson(json);
}
