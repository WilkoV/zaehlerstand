// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Reading _$ReadingFromJson(Map<String, dynamic> json) {
  return _Reading.fromJson(json);
}

/// @nodoc
mixin _$Reading {
  DateTime get date => throw _privateConstructorUsedError;
  int get enteredReading => throw _privateConstructorUsedError;
  int get reading => throw _privateConstructorUsedError;
  bool get isGenerated => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  /// Serializes this Reading to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingCopyWith<Reading> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingCopyWith<$Res> {
  factory $ReadingCopyWith(Reading value, $Res Function(Reading) then) =
      _$ReadingCopyWithImpl<$Res, Reading>;
  @useResult
  $Res call(
      {DateTime date,
      int enteredReading,
      int reading,
      bool isGenerated,
      bool isSynced});
}

/// @nodoc
class _$ReadingCopyWithImpl<$Res, $Val extends Reading>
    implements $ReadingCopyWith<$Res> {
  _$ReadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? enteredReading = null,
    Object? reading = null,
    Object? isGenerated = null,
    Object? isSynced = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      enteredReading: null == enteredReading
          ? _value.enteredReading
          : enteredReading // ignore: cast_nullable_to_non_nullable
              as int,
      reading: null == reading
          ? _value.reading
          : reading // ignore: cast_nullable_to_non_nullable
              as int,
      isGenerated: null == isGenerated
          ? _value.isGenerated
          : isGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReadingImplCopyWith<$Res> implements $ReadingCopyWith<$Res> {
  factory _$$ReadingImplCopyWith(
          _$ReadingImpl value, $Res Function(_$ReadingImpl) then) =
      __$$ReadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      int enteredReading,
      int reading,
      bool isGenerated,
      bool isSynced});
}

/// @nodoc
class __$$ReadingImplCopyWithImpl<$Res>
    extends _$ReadingCopyWithImpl<$Res, _$ReadingImpl>
    implements _$$ReadingImplCopyWith<$Res> {
  __$$ReadingImplCopyWithImpl(
      _$ReadingImpl _value, $Res Function(_$ReadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? enteredReading = null,
    Object? reading = null,
    Object? isGenerated = null,
    Object? isSynced = null,
  }) {
    return _then(_$ReadingImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      enteredReading: null == enteredReading
          ? _value.enteredReading
          : enteredReading // ignore: cast_nullable_to_non_nullable
              as int,
      reading: null == reading
          ? _value.reading
          : reading // ignore: cast_nullable_to_non_nullable
              as int,
      isGenerated: null == isGenerated
          ? _value.isGenerated
          : isGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingImpl implements _Reading {
  _$ReadingImpl(
      {required this.date,
      required this.enteredReading,
      required this.reading,
      required this.isGenerated,
      required this.isSynced});

  factory _$ReadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int enteredReading;
  @override
  final int reading;
  @override
  final bool isGenerated;
  @override
  final bool isSynced;

  @override
  String toString() {
    return 'Reading(date: $date, enteredReading: $enteredReading, reading: $reading, isGenerated: $isGenerated, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.enteredReading, enteredReading) ||
                other.enteredReading == enteredReading) &&
            (identical(other.reading, reading) || other.reading == reading) &&
            (identical(other.isGenerated, isGenerated) ||
                other.isGenerated == isGenerated) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, enteredReading, reading, isGenerated, isSynced);

  /// Create a copy of Reading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingImplCopyWith<_$ReadingImpl> get copyWith =>
      __$$ReadingImplCopyWithImpl<_$ReadingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingImplToJson(
      this,
    );
  }
}

abstract class _Reading implements Reading {
  factory _Reading(
      {required final DateTime date,
      required final int enteredReading,
      required final int reading,
      required final bool isGenerated,
      required final bool isSynced}) = _$ReadingImpl;

  factory _Reading.fromJson(Map<String, dynamic> json) = _$ReadingImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get enteredReading;
  @override
  int get reading;
  @override
  bool get isGenerated;
  @override
  bool get isSynced;

  /// Create a copy of Reading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingImplCopyWith<_$ReadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
