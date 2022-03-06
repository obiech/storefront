// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'otp_verification_screen_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$OtpVerificationScreenArgsTearOff {
  const _$OtpVerificationScreenArgsTearOff();

  _OtpVerificationScreenArgs call(
      {required String phoneNumberIntlFormat,
      required OtpSuccessAction successAction}) {
    return _OtpVerificationScreenArgs(
      phoneNumberIntlFormat: phoneNumberIntlFormat,
      successAction: successAction,
    );
  }
}

/// @nodoc
const $OtpVerificationScreenArgs = _$OtpVerificationScreenArgsTearOff();

/// @nodoc
mixin _$OtpVerificationScreenArgs {
  String get phoneNumberIntlFormat => throw _privateConstructorUsedError;
  OtpSuccessAction get successAction => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OtpVerificationScreenArgsCopyWith<OtpVerificationScreenArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerificationScreenArgsCopyWith<$Res> {
  factory $OtpVerificationScreenArgsCopyWith(OtpVerificationScreenArgs value,
          $Res Function(OtpVerificationScreenArgs) then) =
      _$OtpVerificationScreenArgsCopyWithImpl<$Res>;
  $Res call({String phoneNumberIntlFormat, OtpSuccessAction successAction});
}

/// @nodoc
class _$OtpVerificationScreenArgsCopyWithImpl<$Res>
    implements $OtpVerificationScreenArgsCopyWith<$Res> {
  _$OtpVerificationScreenArgsCopyWithImpl(this._value, this._then);

  final OtpVerificationScreenArgs _value;
  // ignore: unused_field
  final $Res Function(OtpVerificationScreenArgs) _then;

  @override
  $Res call({
    Object? phoneNumberIntlFormat = freezed,
    Object? successAction = freezed,
  }) {
    return _then(_value.copyWith(
      phoneNumberIntlFormat: phoneNumberIntlFormat == freezed
          ? _value.phoneNumberIntlFormat
          : phoneNumberIntlFormat // ignore: cast_nullable_to_non_nullable
              as String,
      successAction: successAction == freezed
          ? _value.successAction
          : successAction // ignore: cast_nullable_to_non_nullable
              as OtpSuccessAction,
    ));
  }
}

/// @nodoc
abstract class _$OtpVerificationScreenArgsCopyWith<$Res>
    implements $OtpVerificationScreenArgsCopyWith<$Res> {
  factory _$OtpVerificationScreenArgsCopyWith(_OtpVerificationScreenArgs value,
          $Res Function(_OtpVerificationScreenArgs) then) =
      __$OtpVerificationScreenArgsCopyWithImpl<$Res>;
  @override
  $Res call({String phoneNumberIntlFormat, OtpSuccessAction successAction});
}

/// @nodoc
class __$OtpVerificationScreenArgsCopyWithImpl<$Res>
    extends _$OtpVerificationScreenArgsCopyWithImpl<$Res>
    implements _$OtpVerificationScreenArgsCopyWith<$Res> {
  __$OtpVerificationScreenArgsCopyWithImpl(_OtpVerificationScreenArgs _value,
      $Res Function(_OtpVerificationScreenArgs) _then)
      : super(_value, (v) => _then(v as _OtpVerificationScreenArgs));

  @override
  _OtpVerificationScreenArgs get _value =>
      super._value as _OtpVerificationScreenArgs;

  @override
  $Res call({
    Object? phoneNumberIntlFormat = freezed,
    Object? successAction = freezed,
  }) {
    return _then(_OtpVerificationScreenArgs(
      phoneNumberIntlFormat: phoneNumberIntlFormat == freezed
          ? _value.phoneNumberIntlFormat
          : phoneNumberIntlFormat // ignore: cast_nullable_to_non_nullable
              as String,
      successAction: successAction == freezed
          ? _value.successAction
          : successAction // ignore: cast_nullable_to_non_nullable
              as OtpSuccessAction,
    ));
  }
}

/// @nodoc

class _$_OtpVerificationScreenArgs implements _OtpVerificationScreenArgs {
  const _$_OtpVerificationScreenArgs(
      {required this.phoneNumberIntlFormat, required this.successAction});

  @override
  final String phoneNumberIntlFormat;
  @override
  final OtpSuccessAction successAction;

  @override
  String toString() {
    return 'OtpVerificationScreenArgs(phoneNumberIntlFormat: $phoneNumberIntlFormat, successAction: $successAction)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OtpVerificationScreenArgs &&
            const DeepCollectionEquality()
                .equals(other.phoneNumberIntlFormat, phoneNumberIntlFormat) &&
            const DeepCollectionEquality()
                .equals(other.successAction, successAction));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(phoneNumberIntlFormat),
      const DeepCollectionEquality().hash(successAction));

  @JsonKey(ignore: true)
  @override
  _$OtpVerificationScreenArgsCopyWith<_OtpVerificationScreenArgs>
      get copyWith =>
          __$OtpVerificationScreenArgsCopyWithImpl<_OtpVerificationScreenArgs>(
              this, _$identity);
}

abstract class _OtpVerificationScreenArgs implements OtpVerificationScreenArgs {
  const factory _OtpVerificationScreenArgs(
      {required String phoneNumberIntlFormat,
      required OtpSuccessAction successAction}) = _$_OtpVerificationScreenArgs;

  @override
  String get phoneNumberIntlFormat;
  @override
  OtpSuccessAction get successAction;
  @override
  @JsonKey(ignore: true)
  _$OtpVerificationScreenArgsCopyWith<_OtpVerificationScreenArgs>
      get copyWith => throw _privateConstructorUsedError;
}
