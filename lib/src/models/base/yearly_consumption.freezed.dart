// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'yearly_consumption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$YearlyConsumption {
  int get year => throw _privateConstructorUsedError;
  int get consumption => throw _privateConstructorUsedError;

  /// Create a copy of YearlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $YearlyConsumptionCopyWith<YearlyConsumption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YearlyConsumptionCopyWith<$Res> {
  factory $YearlyConsumptionCopyWith(
          YearlyConsumption value, $Res Function(YearlyConsumption) then) =
      _$YearlyConsumptionCopyWithImpl<$Res, YearlyConsumption>;
  @useResult
  $Res call({int year, int consumption});
}

/// @nodoc
class _$YearlyConsumptionCopyWithImpl<$Res, $Val extends YearlyConsumption>
    implements $YearlyConsumptionCopyWith<$Res> {
  _$YearlyConsumptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of YearlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? consumption = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      consumption: null == consumption
          ? _value.consumption
          : consumption // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$YearlyConsumptionImplCopyWith<$Res>
    implements $YearlyConsumptionCopyWith<$Res> {
  factory _$$YearlyConsumptionImplCopyWith(_$YearlyConsumptionImpl value,
          $Res Function(_$YearlyConsumptionImpl) then) =
      __$$YearlyConsumptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int year, int consumption});
}

/// @nodoc
class __$$YearlyConsumptionImplCopyWithImpl<$Res>
    extends _$YearlyConsumptionCopyWithImpl<$Res, _$YearlyConsumptionImpl>
    implements _$$YearlyConsumptionImplCopyWith<$Res> {
  __$$YearlyConsumptionImplCopyWithImpl(_$YearlyConsumptionImpl _value,
      $Res Function(_$YearlyConsumptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of YearlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? consumption = null,
  }) {
    return _then(_$YearlyConsumptionImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      consumption: null == consumption
          ? _value.consumption
          : consumption // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$YearlyConsumptionImpl implements _YearlyConsumption {
  _$YearlyConsumptionImpl({required this.year, required this.consumption});

  @override
  final int year;
  @override
  final int consumption;

  @override
  String toString() {
    return 'YearlyConsumption(year: $year, consumption: $consumption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YearlyConsumptionImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.consumption, consumption) ||
                other.consumption == consumption));
  }

  @override
  int get hashCode => Object.hash(runtimeType, year, consumption);

  /// Create a copy of YearlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$YearlyConsumptionImplCopyWith<_$YearlyConsumptionImpl> get copyWith =>
      __$$YearlyConsumptionImplCopyWithImpl<_$YearlyConsumptionImpl>(
          this, _$identity);
}

abstract class _YearlyConsumption implements YearlyConsumption {
  factory _YearlyConsumption(
      {required final int year,
      required final int consumption}) = _$YearlyConsumptionImpl;

  @override
  int get year;
  @override
  int get consumption;

  /// Create a copy of YearlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YearlyConsumptionImplCopyWith<_$YearlyConsumptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
