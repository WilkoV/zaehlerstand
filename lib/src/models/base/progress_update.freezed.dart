// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProgressUpdate {
  int get current => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Create a copy of ProgressUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressUpdateCopyWith<ProgressUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressUpdateCopyWith<$Res> {
  factory $ProgressUpdateCopyWith(
          ProgressUpdate value, $Res Function(ProgressUpdate) then) =
      _$ProgressUpdateCopyWithImpl<$Res, ProgressUpdate>;
  @useResult
  $Res call({int current, int total});
}

/// @nodoc
class _$ProgressUpdateCopyWithImpl<$Res, $Val extends ProgressUpdate>
    implements $ProgressUpdateCopyWith<$Res> {
  _$ProgressUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgressUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressUpdateImplCopyWith<$Res>
    implements $ProgressUpdateCopyWith<$Res> {
  factory _$$ProgressUpdateImplCopyWith(_$ProgressUpdateImpl value,
          $Res Function(_$ProgressUpdateImpl) then) =
      __$$ProgressUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int current, int total});
}

/// @nodoc
class __$$ProgressUpdateImplCopyWithImpl<$Res>
    extends _$ProgressUpdateCopyWithImpl<$Res, _$ProgressUpdateImpl>
    implements _$$ProgressUpdateImplCopyWith<$Res> {
  __$$ProgressUpdateImplCopyWithImpl(
      _$ProgressUpdateImpl _value, $Res Function(_$ProgressUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProgressUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? total = null,
  }) {
    return _then(_$ProgressUpdateImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ProgressUpdateImpl implements _ProgressUpdate {
  _$ProgressUpdateImpl({required this.current, required this.total});

  @override
  final int current;
  @override
  final int total;

  @override
  String toString() {
    return 'ProgressUpdate(current: $current, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressUpdateImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, current, total);

  /// Create a copy of ProgressUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressUpdateImplCopyWith<_$ProgressUpdateImpl> get copyWith =>
      __$$ProgressUpdateImplCopyWithImpl<_$ProgressUpdateImpl>(
          this, _$identity);
}

abstract class _ProgressUpdate implements ProgressUpdate {
  factory _ProgressUpdate(
      {required final int current,
      required final int total}) = _$ProgressUpdateImpl;

  @override
  int get current;
  @override
  int get total;

  /// Create a copy of ProgressUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressUpdateImplCopyWith<_$ProgressUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
