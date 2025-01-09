import 'package:freezed_annotation/freezed_annotation.dart';

part 'daddys_reading_data.freezed.dart';
part 'daddys_reading_data.g.dart';

@freezed
class DaddysReadingData with _$DaddysReadingData {

  factory DaddysReadingData({
    required int consumption,
    double? minTemp,
    double? maxTemp,
    double? minFeelsLike,
    double? maxFeelsLike,
  }) = _DaddysReadingData;

  factory DaddysReadingData.fromJson(Map<String, dynamic> json) => _$DaddysReadingDataFromJson(json);
}