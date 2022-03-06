// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'account_verification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AccountVerificationStateTearOff {
  const _$AccountVerificationStateTearOff();

  _OtpVerificationState call(
      {dynamic status = AccountVerificationStatus.initialState,
      String? errMsg}) {
    return _OtpVerificationState(
      status: status,
      errMsg: errMsg,
    );
  }
}

/// @nodoc
const $AccountVerificationState = _$AccountVerificationStateTearOff();

/// @nodoc
mixin _$AccountVerificationState {
  dynamic get status => throw _privateConstructorUsedError;
  String? get errMsg => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountVerificationStateCopyWith<AccountVerificationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountVerificationStateCopyWith<$Res> {
  factory $AccountVerificationStateCopyWith(AccountVerificationState value,
          $Res Function(AccountVerificationState) then) =
      _$AccountVerificationStateCopyWithImpl<$Res>;
  $Res call({dynamic status, String? errMsg});
}

/// @nodoc
class _$AccountVerificationStateCopyWithImpl<$Res>
    implements $AccountVerificationStateCopyWith<$Res> {
  _$AccountVerificationStateCopyWithImpl(this._value, this._then);

  final AccountVerificationState _value;
  // ignore: unused_field
  final $Res Function(AccountVerificationState) _then;

  @override
  $Res call({
    Object? status = freezed,
    Object? errMsg = freezed,
  }) {
    return _then(_value.copyWith(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      errMsg: errMsg == freezed
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$OtpVerificationStateCopyWith<$Res>
    implements $AccountVerificationStateCopyWith<$Res> {
  factory _$OtpVerificationStateCopyWith(_OtpVerificationState value,
          $Res Function(_OtpVerificationState) then) =
      __$OtpVerificationStateCopyWithImpl<$Res>;
  @override
  $Res call({dynamic status, String? errMsg});
}

/// @nodoc
class __$OtpVerificationStateCopyWithImpl<$Res>
    extends _$AccountVerificationStateCopyWithImpl<$Res>
    implements _$OtpVerificationStateCopyWith<$Res> {
  __$OtpVerificationStateCopyWithImpl(
      _OtpVerificationState _value, $Res Function(_OtpVerificationState) _then)
      : super(_value, (v) => _then(v as _OtpVerificationState));

  @override
  _OtpVerificationState get _value => super._value as _OtpVerificationState;

  @override
  $Res call({
    Object? status = freezed,
    Object? errMsg = freezed,
  }) {
    return _then(_OtpVerificationState(
      status: status == freezed ? _value.status : status,
      errMsg: errMsg == freezed
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_OtpVerificationState implements _OtpVerificationState {
  const _$_OtpVerificationState(
      {this.status = AccountVerificationStatus.initialState, this.errMsg});

  @JsonKey()
  @override
  final dynamic status;
  @override
  final String? errMsg;

  @override
  String toString() {
    return 'AccountVerificationState(status: $status, errMsg: $errMsg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OtpVerificationState &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.errMsg, errMsg));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(errMsg));

  @JsonKey(ignore: true)
  @override
  _$OtpVerificationStateCopyWith<_OtpVerificationState> get copyWith =>
      __$OtpVerificationStateCopyWithImpl<_OtpVerificationState>(
          this, _$identity);
}

abstract class _OtpVerificationState implements AccountVerificationState {
  const factory _OtpVerificationState({dynamic status, String? errMsg}) =
      _$_OtpVerificationState;

  @override
  dynamic get status;
  @override
  String? get errMsg;
  @override
  @JsonKey(ignore: true)
  _$OtpVerificationStateCopyWith<_OtpVerificationState> get copyWith =>
      throw _privateConstructorUsedError;
}
