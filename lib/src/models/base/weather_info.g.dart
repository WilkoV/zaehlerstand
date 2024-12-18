// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherInfoImpl _$$WeatherInfoImplFromJson(Map<String, dynamic> json) =>
    _$WeatherInfoImpl(
      date: DateTime.parse(json['date'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      isGenerated: json['isGenerated'] as bool,
    );

Map<String, dynamic> _$$WeatherInfoImplToJson(_$WeatherInfoImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'temperature': instance.temperature,
      'isGenerated': instance.isGenerated,
    };
