// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'average_consumption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AverageConsumption {
  String get period => throw _privateConstructorUsedError;
  int get consumption => throw _privateConstructorUsedError;

  /// Create a copy of AverageConsumption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AverageConsumptionCopyWith<AverageConsumption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AverageConsumptionCopyWith<$Res> {
  factory $AverageConsumptionCopyWith(
          AverageConsumption value, $Res Function(AverageConsumption) then) =
      _$AverageConsumptionCopyWithImpl<$Res, AverageConsumption>;
  @useResult
  $Res call({String period, int consumption});
}

/// @nodoc
class _$AverageConsumptionCopyWithImpl<$Res, $Val extends AverageConsumption>
    implements $AverageConsumptionCopyWith<$Res> {
  _$AverageConsumptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AverageConsumption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? consumption = null,
  }) {
    return _then(_value.copyWith(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      consumption: null == consumption
          ? _value.consumption
          : consumption // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AverageConsumptionImplCopyWith<$Res>
    implements $AverageConsumptionCopyWith<$Res> {
  factory _$$AverageConsumptionImplCopyWith(_$AverageConsumptionImpl value,
          $Res Function(_$AverageConsumptionImpl) then) =
      __$$AverageConsumptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String period, int consumption});
}

/// @nodoc
class __$$AverageConsumptionImplCopyWithImpl<$Res>
    extends _$AverageConsumptionCopyWithImpl<$Res, _$AverageConsumptionImpl>
    implements _$$AverageConsumptionImplCopyWith<$Res> {
  __$$AverageConsumptionImplCopyWithImpl(_$AverageConsumptionImpl _value,
      $Res Function(_$AverageConsumptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AverageConsumption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? consumption = null,
  }) {
    return _then(_$AverageConsumptionImpl(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      consumption: null == consumption
          ? _value.consumption
          : consumption // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AverageConsumptionImpl implements _AverageConsumption {
  _$AverageConsumptionImpl({required this.period, required this.consumption});

  @override
  final String period;
  @override
  final int consumption;

  @override
  String toString() {
    return 'AverageConsumption(period: $period, consumption: $consumption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AverageConsumptionImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.consumption, consumption) ||
                other.consumption == consumption));
  }

  @override
  int get hashCode => Object.hash(runtimeType, period, consumption);

  /// Create a copy of AverageConsumption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AverageConsumptionImplCopyWith<_$AverageConsumptionImpl> get copyWith =>
      __$$AverageConsumptionImplCopyWithImpl<_$AverageConsumptionImpl>(
          this, _$identity);
}

abstract class _AverageConsumption implements AverageConsumption {
  factory _AverageConsumption(
      {required final String period,
      required final int consumption}) = _$AverageConsumptionImpl;

  @override
  String get period;
  @override
  int get consumption;

  /// Create a copy of AverageConsumption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AverageConsumptionImplCopyWith<_$AverageConsumptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
