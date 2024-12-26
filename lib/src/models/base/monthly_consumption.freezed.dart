// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_consumption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlyConsumption {
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  int get consumption => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyConsumptionCopyWith<MonthlyConsumption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyConsumptionCopyWith<$Res> {
  factory $MonthlyConsumptionCopyWith(
          MonthlyConsumption value, $Res Function(MonthlyConsumption) then) =
      _$MonthlyConsumptionCopyWithImpl<$Res, MonthlyConsumption>;
  @useResult
  $Res call({int year, int month, int consumption});
}

/// @nodoc
class _$MonthlyConsumptionCopyWithImpl<$Res, $Val extends MonthlyConsumption>
    implements $MonthlyConsumptionCopyWith<$Res> {
  _$MonthlyConsumptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? consumption = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      consumption: null == consumption
          ? _value.consumption
          : consumption // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyConsumptionImplCopyWith<$Res>
    implements $MonthlyConsumptionCopyWith<$Res> {
  factory _$$MonthlyConsumptionImplCopyWith(_$MonthlyConsumptionImpl value,
          $Res Function(_$MonthlyConsumptionImpl) then) =
      __$$MonthlyConsumptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int year, int month, int consumption});
}

/// @nodoc
class __$$MonthlyConsumptionImplCopyWithImpl<$Res>
    extends _$MonthlyConsumptionCopyWithImpl<$Res, _$MonthlyConsumptionImpl>
    implements _$$MonthlyConsumptionImplCopyWith<$Res> {
  __$$MonthlyConsumptionImplCopyWithImpl(_$MonthlyConsumptionImpl _value,
      $Res Function(_$MonthlyConsumptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? consumption = null,
  }) {
    return _then(_$MonthlyConsumptionImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      consumption: null == consumption
          ? _value.consumption
          : consumption // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MonthlyConsumptionImpl implements _MonthlyConsumption {
  _$MonthlyConsumptionImpl(
      {required this.year, required this.month, required this.consumption});

  @override
  final int year;
  @override
  final int month;
  @override
  final int consumption;

  @override
  String toString() {
    return 'MonthlyConsumption(year: $year, month: $month, consumption: $consumption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyConsumptionImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.consumption, consumption) ||
                other.consumption == consumption));
  }

  @override
  int get hashCode => Object.hash(runtimeType, year, month, consumption);

  /// Create a copy of MonthlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyConsumptionImplCopyWith<_$MonthlyConsumptionImpl> get copyWith =>
      __$$MonthlyConsumptionImplCopyWithImpl<_$MonthlyConsumptionImpl>(
          this, _$identity);
}

abstract class _MonthlyConsumption implements MonthlyConsumption {
  factory _MonthlyConsumption(
      {required final int year,
      required final int month,
      required final int consumption}) = _$MonthlyConsumptionImpl;

  @override
  int get year;
  @override
  int get month;
  @override
  int get consumption;

  /// Create a copy of MonthlyConsumption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyConsumptionImplCopyWith<_$MonthlyConsumptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
