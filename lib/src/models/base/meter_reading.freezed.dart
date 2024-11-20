// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meter_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MeterReading _$MeterReadingFromJson(Map<String, dynamic> json) {
  return _MeterReading.fromJson(json);
}

/// @nodoc
mixin _$MeterReading {
  DateTime get date => throw _privateConstructorUsedError;
  int get reading => throw _privateConstructorUsedError;
  bool get isGenerated => throw _privateConstructorUsedError;
  int get enteredReading => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  /// Serializes this MeterReading to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MeterReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeterReadingCopyWith<MeterReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeterReadingCopyWith<$Res> {
  factory $MeterReadingCopyWith(
          MeterReading value, $Res Function(MeterReading) then) =
      _$MeterReadingCopyWithImpl<$Res, MeterReading>;
  @useResult
  $Res call(
      {DateTime date,
      int reading,
      bool isGenerated,
      int enteredReading,
      bool isSynced});
}

/// @nodoc
class _$MeterReadingCopyWithImpl<$Res, $Val extends MeterReading>
    implements $MeterReadingCopyWith<$Res> {
  _$MeterReadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeterReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? reading = null,
    Object? isGenerated = null,
    Object? enteredReading = null,
    Object? isSynced = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reading: null == reading
          ? _value.reading
          : reading // ignore: cast_nullable_to_non_nullable
              as int,
      isGenerated: null == isGenerated
          ? _value.isGenerated
          : isGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      enteredReading: null == enteredReading
          ? _value.enteredReading
          : enteredReading // ignore: cast_nullable_to_non_nullable
              as int,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeterReadingImplCopyWith<$Res>
    implements $MeterReadingCopyWith<$Res> {
  factory _$$MeterReadingImplCopyWith(
          _$MeterReadingImpl value, $Res Function(_$MeterReadingImpl) then) =
      __$$MeterReadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      int reading,
      bool isGenerated,
      int enteredReading,
      bool isSynced});
}

/// @nodoc
class __$$MeterReadingImplCopyWithImpl<$Res>
    extends _$MeterReadingCopyWithImpl<$Res, _$MeterReadingImpl>
    implements _$$MeterReadingImplCopyWith<$Res> {
  __$$MeterReadingImplCopyWithImpl(
      _$MeterReadingImpl _value, $Res Function(_$MeterReadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MeterReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? reading = null,
    Object? isGenerated = null,
    Object? enteredReading = null,
    Object? isSynced = null,
  }) {
    return _then(_$MeterReadingImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reading: null == reading
          ? _value.reading
          : reading // ignore: cast_nullable_to_non_nullable
              as int,
      isGenerated: null == isGenerated
          ? _value.isGenerated
          : isGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      enteredReading: null == enteredReading
          ? _value.enteredReading
          : enteredReading // ignore: cast_nullable_to_non_nullable
              as int,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeterReadingImpl implements _MeterReading {
  _$MeterReadingImpl(
      {required this.date,
      required this.reading,
      required this.isGenerated,
      required this.enteredReading,
      required this.isSynced});

  factory _$MeterReadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeterReadingImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int reading;
  @override
  final bool isGenerated;
  @override
  final int enteredReading;
  @override
  final bool isSynced;

  @override
  String toString() {
    return 'MeterReading(date: $date, reading: $reading, isGenerated: $isGenerated, enteredReading: $enteredReading, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeterReadingImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.reading, reading) || other.reading == reading) &&
            (identical(other.isGenerated, isGenerated) ||
                other.isGenerated == isGenerated) &&
            (identical(other.enteredReading, enteredReading) ||
                other.enteredReading == enteredReading) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, reading, isGenerated, enteredReading, isSynced);

  /// Create a copy of MeterReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeterReadingImplCopyWith<_$MeterReadingImpl> get copyWith =>
      __$$MeterReadingImplCopyWithImpl<_$MeterReadingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeterReadingImplToJson(
      this,
    );
  }
}

abstract class _MeterReading implements MeterReading {
  factory _MeterReading(
      {required final DateTime date,
      required final int reading,
      required final bool isGenerated,
      required final int enteredReading,
      required final bool isSynced}) = _$MeterReadingImpl;

  factory _MeterReading.fromJson(Map<String, dynamic> json) =
      _$MeterReadingImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get reading;
  @override
  bool get isGenerated;
  @override
  int get enteredReading;
  @override
  bool get isSynced;

  /// Create a copy of MeterReading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeterReadingImplCopyWith<_$MeterReadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
