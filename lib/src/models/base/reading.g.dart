// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReadingImpl _$$ReadingImplFromJson(Map<String, dynamic> json) =>
    _$ReadingImpl(
      date: DateTime.parse(json['date'] as String),
      enteredReading: (json['enteredReading'] as num).toInt(),
      reading: (json['reading'] as num).toInt(),
      isGenerated: json['isGenerated'] as bool,
      isSynced: json['isSynced'] as bool,
    );

Map<String, dynamic> _$$ReadingImplToJson(_$ReadingImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'enteredReading': instance.enteredReading,
      'reading': instance.reading,
      'isGenerated': instance.isGenerated,
      'isSynced': instance.isSynced,
    };
