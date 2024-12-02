// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherInfoImpl _$$WeatherInfoImplFromJson(Map<String, dynamic> json) =>
    _$WeatherInfoImpl(
      date: DateTime.parse(json['date'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      feelsLikeTemperature: (json['feelsLikeTemperature'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      icon: json['icon'] as String,
      isGenerated: json['isGenerated'] as bool,
    );

Map<String, dynamic> _$$WeatherInfoImplToJson(_$WeatherInfoImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'temperature': instance.temperature,
      'feelsLikeTemperature': instance.feelsLikeTemperature,
      'windSpeed': instance.windSpeed,
      'icon': instance.icon,
      'isGenerated': instance.isGenerated,
    };
