// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeterReadingImpl _$$MeterReadingImplFromJson(Map<String, dynamic> json) =>
    _$MeterReadingImpl(
      date: DateTime.parse(json['date'] as String),
      reading: (json['reading'] as num).toInt(),
    );

Map<String, dynamic> _$$MeterReadingImplToJson(_$MeterReadingImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'reading': instance.reading,
    };
