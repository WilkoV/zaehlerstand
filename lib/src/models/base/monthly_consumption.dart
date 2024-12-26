import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_consumption.freezed.dart';

@freezed
class MonthlyConsumption with _$MonthlyConsumption {
  factory MonthlyConsumption({
    required int year,
    required int month,
    required int consumption,
  }) = _MonthlyConsumption;
}
