import 'package:freezed_annotation/freezed_annotation.dart';

part 'yearly_consumption.freezed.dart';

@freezed
class YearlyConsumption with _$YearlyConsumption {
  factory YearlyConsumption({
    required int year,
    required int consumption,
  }) = _YearlyConsumption;
}
