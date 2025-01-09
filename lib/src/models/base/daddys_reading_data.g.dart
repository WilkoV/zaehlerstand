// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daddys_reading_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DaddysReadingDataImpl _$$DaddysReadingDataImplFromJson(
        Map<String, dynamic> json) =>
    _$DaddysReadingDataImpl(
      consumption: (json['consumption'] as num).toInt(),
      minTemp: (json['minTemp'] as num?)?.toDouble(),
      maxTemp: (json['maxTemp'] as num?)?.toDouble(),
      minFeelsLike: (json['minFeelsLike'] as num?)?.toDouble(),
      maxFeelsLike: (json['maxFeelsLike'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DaddysReadingDataImplToJson(
        _$DaddysReadingDataImpl instance) =>
    <String, dynamic>{
      'consumption': instance.consumption,
      'minTemp': instance.minTemp,
      'maxTemp': instance.maxTemp,
      'minFeelsLike': instance.minFeelsLike,
      'maxFeelsLike': instance.maxFeelsLike,
    };
