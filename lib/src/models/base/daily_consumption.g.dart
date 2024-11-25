// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_consumption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyConsumptionImpl _$$DailyConsumptionImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyConsumptionImpl(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toInt(),
    );

Map<String, dynamic> _$$DailyConsumptionImplToJson(
        _$DailyConsumptionImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'value': instance.value,
    };
