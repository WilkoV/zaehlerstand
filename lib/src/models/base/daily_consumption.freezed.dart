// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_consumption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyConsumption _$DailyConsumptionFromJson(Map<String, dynamic> json) {
  return _DailyConsumption.fromJson(json);
}

/// @nodoc
mixin _$DailyConsumption {
  DateTime get date => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;

  /// Serializes this DailyConsumption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyConsumptionCopyWith<DailyConsumption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyConsumptionCopyWith<$Res> {
  factory $DailyConsumptionCopyWith(
          DailyConsumption value, $Res Function(DailyConsumption) then) =
      _$DailyConsumptionCopyWithImpl<$Res, DailyConsumption>;
  @useResult
  $Res call({DateTime date, int value});
}

/// @nodoc
class _$DailyConsumptionCopyWithImpl<$Res, $Val extends DailyConsumption>
    implements $DailyConsumptionCopyWith<$Res> {
  _$DailyConsumptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyConsumptionImplCopyWith<$Res>
    implements $DailyConsumptionCopyWith<$Res> {
  factory _$$DailyConsumptionImplCopyWith(_$DailyConsumptionImpl value,
          $Res Function(_$DailyConsumptionImpl) then) =
      __$$DailyConsumptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int value});
}

/// @nodoc
class __$$DailyConsumptionImplCopyWithImpl<$Res>
    extends _$DailyConsumptionCopyWithImpl<$Res, _$DailyConsumptionImpl>
    implements _$$DailyConsumptionImplCopyWith<$Res> {
  __$$DailyConsumptionImplCopyWithImpl(_$DailyConsumptionImpl _value,
      $Res Function(_$DailyConsumptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
  }) {
    return _then(_$DailyConsumptionImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyConsumptionImpl implements _DailyConsumption {
  _$DailyConsumptionImpl({required this.date, required this.value});

  factory _$DailyConsumptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyConsumptionImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int value;

  @override
  String toString() {
    return 'DailyConsumption(date: $date, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyConsumptionImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, value);

  /// Create a copy of DailyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyConsumptionImplCopyWith<_$DailyConsumptionImpl> get copyWith =>
      __$$DailyConsumptionImplCopyWithImpl<_$DailyConsumptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyConsumptionImplToJson(
      this,
    );
  }
}

abstract class _DailyConsumption implements DailyConsumption {
  factory _DailyConsumption(
      {required final DateTime date,
      required final int value}) = _$DailyConsumptionImpl;

  factory _DailyConsumption.fromJson(Map<String, dynamic> json) =
      _$DailyConsumptionImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get value;

  /// Create a copy of DailyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyConsumptionImplCopyWith<_$DailyConsumptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
