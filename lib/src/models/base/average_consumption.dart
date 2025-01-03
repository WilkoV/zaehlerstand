import 'package:freezed_annotation/freezed_annotation.dart';

part 'average_consumption.freezed.dart';

@freezed
class AverageConsumption with _$AverageConsumption {
  factory AverageConsumption({
    required String period,
    required int consumption,
  }) = _AverageConsumption;
}
