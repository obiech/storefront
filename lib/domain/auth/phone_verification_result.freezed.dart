// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'phone_verification_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PhoneVerificationResultTearOff {
  const _$PhoneVerificationResultTearOff();

  _PhoneVerificationResult call(
      {required PhoneVerificationStatus status,
      PhoneVerificationException? exception = null}) {
    return _PhoneVerificationResult(
      status: status,
      exception: exception,
    );
  }
}

/// @nodoc
const $PhoneVerificationResult = _$PhoneVerificationResultTearOff();

/// @nodoc
mixin _$PhoneVerificationResult {
  PhoneVerificationStatus get status => throw _privateConstructorUsedError;
  PhoneVerificationException? get exception =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PhoneVerificationResultCopyWith<PhoneVerificationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneVerificationResultCopyWith<$Res> {
  factory $PhoneVerificationResultCopyWith(PhoneVerificationResult value,
          $Res Function(PhoneVerificationResult) then) =
      _$PhoneVerificationResultCopyWithImpl<$Res>;
  $Res call(
      {PhoneVerificationStatus status, PhoneVerificationException? exception});
}

/// @nodoc
class _$PhoneVerificationResultCopyWithImpl<$Res>
    implements $PhoneVerificationResultCopyWith<$Res> {
  _$PhoneVerificationResultCopyWithImpl(this._value, this._then);

  final PhoneVerificationResult _value;
  // ignore: unused_field
  final $Res Function(PhoneVerificationResult) _then;

  @override
  $Res call({
    Object? status = freezed,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PhoneVerificationStatus,
      exception: exception == freezed
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as PhoneVerificationException?,
    ));
  }
}

/// @nodoc
abstract class _$PhoneVerificationResultCopyWith<$Res>
    implements $PhoneVerificationResultCopyWith<$Res> {
  factory _$PhoneVerificationResultCopyWith(_PhoneVerificationResult value,
          $Res Function(_PhoneVerificationResult) then) =
      __$PhoneVerificationResultCopyWithImpl<$Res>;
  @override
  $Res call(
      {PhoneVerificationStatus status, PhoneVerificationException? exception});
}

/// @nodoc
class __$PhoneVerificationResultCopyWithImpl<$Res>
    extends _$PhoneVerificationResultCopyWithImpl<$Res>
    implements _$PhoneVerificationResultCopyWith<$Res> {
  __$PhoneVerificationResultCopyWithImpl(_PhoneVerificationResult _value,
      $Res Function(_PhoneVerificationResult) _then)
      : super(_value, (v) => _then(v as _PhoneVerificationResult));

  @override
  _PhoneVerificationResult get _value =>
      super._value as _PhoneVerificationResult;

  @override
  $Res call({
    Object? status = freezed,
    Object? exception = freezed,
  }) {
    return _then(_PhoneVerificationResult(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PhoneVerificationStatus,
      exception: exception == freezed
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as PhoneVerificationException?,
    ));
  }
}

/// @nodoc

class _$_PhoneVerificationResult implements _PhoneVerificationResult {
  const _$_PhoneVerificationResult(
      {required this.status, this.exception = null})
      : assert(status != PhoneVerificationStatus.error || exception != null);

  @override
  final PhoneVerificationStatus status;
  @JsonKey()
  @override
  final PhoneVerificationException? exception;

  @override
  String toString() {
    return 'PhoneVerificationResult(status: $status, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PhoneVerificationResult &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(exception));

  @JsonKey(ignore: true)
  @override
  _$PhoneVerificationResultCopyWith<_PhoneVerificationResult> get copyWith =>
      __$PhoneVerificationResultCopyWithImpl<_PhoneVerificationResult>(
          this, _$identity);
}

abstract class _PhoneVerificationResult implements PhoneVerificationResult {
  const factory _PhoneVerificationResult(
      {required PhoneVerificationStatus status,
      PhoneVerificationException? exception}) = _$_PhoneVerificationResult;

  @override
  PhoneVerificationStatus get status;
  @override
  PhoneVerificationException? get exception;
  @override
  @JsonKey(ignore: true)
  _$PhoneVerificationResultCopyWith<_PhoneVerificationResult> get copyWith =>
      throw _privateConstructorUsedError;
}
