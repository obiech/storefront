// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'account_availability_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AccountAvailabilityStateTearOff {
  const _$AccountAvailabilityStateTearOff();

  _AccountAvailabilityState call(
      {dynamic status = AccountAvailabilityStatus.initialState,
      String? errMsg,
      int? errStatusCode}) {
    return _AccountAvailabilityState(
      status: status,
      errMsg: errMsg,
      errStatusCode: errStatusCode,
    );
  }
}

/// @nodoc
const $AccountAvailabilityState = _$AccountAvailabilityStateTearOff();

/// @nodoc
mixin _$AccountAvailabilityState {
  dynamic get status => throw _privateConstructorUsedError;
  String? get errMsg => throw _privateConstructorUsedError;
  int? get errStatusCode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountAvailabilityStateCopyWith<AccountAvailabilityState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountAvailabilityStateCopyWith<$Res> {
  factory $AccountAvailabilityStateCopyWith(AccountAvailabilityState value,
          $Res Function(AccountAvailabilityState) then) =
      _$AccountAvailabilityStateCopyWithImpl<$Res>;
  $Res call({dynamic status, String? errMsg, int? errStatusCode});
}

/// @nodoc
class _$AccountAvailabilityStateCopyWithImpl<$Res>
    implements $AccountAvailabilityStateCopyWith<$Res> {
  _$AccountAvailabilityStateCopyWithImpl(this._value, this._then);

  final AccountAvailabilityState _value;
  // ignore: unused_field
  final $Res Function(AccountAvailabilityState) _then;

  @override
  $Res call({
    Object? status = freezed,
    Object? errMsg = freezed,
    Object? errStatusCode = freezed,
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
      errStatusCode: errStatusCode == freezed
          ? _value.errStatusCode
          : errStatusCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$AccountAvailabilityStateCopyWith<$Res>
    implements $AccountAvailabilityStateCopyWith<$Res> {
  factory _$AccountAvailabilityStateCopyWith(_AccountAvailabilityState value,
          $Res Function(_AccountAvailabilityState) then) =
      __$AccountAvailabilityStateCopyWithImpl<$Res>;
  @override
  $Res call({dynamic status, String? errMsg, int? errStatusCode});
}

/// @nodoc
class __$AccountAvailabilityStateCopyWithImpl<$Res>
    extends _$AccountAvailabilityStateCopyWithImpl<$Res>
    implements _$AccountAvailabilityStateCopyWith<$Res> {
  __$AccountAvailabilityStateCopyWithImpl(_AccountAvailabilityState _value,
      $Res Function(_AccountAvailabilityState) _then)
      : super(_value, (v) => _then(v as _AccountAvailabilityState));

  @override
  _AccountAvailabilityState get _value =>
      super._value as _AccountAvailabilityState;

  @override
  $Res call({
    Object? status = freezed,
    Object? errMsg = freezed,
    Object? errStatusCode = freezed,
  }) {
    return _then(_AccountAvailabilityState(
      status: status == freezed ? _value.status : status,
      errMsg: errMsg == freezed
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String?,
      errStatusCode: errStatusCode == freezed
          ? _value.errStatusCode
          : errStatusCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$_AccountAvailabilityState implements _AccountAvailabilityState {
  const _$_AccountAvailabilityState(
      {this.status = AccountAvailabilityStatus.initialState,
      this.errMsg,
      this.errStatusCode});

  @JsonKey()
  @override
  final dynamic status;
  @override
  final String? errMsg;
  @override
  final int? errStatusCode;

  @override
  String toString() {
    return 'AccountAvailabilityState(status: $status, errMsg: $errMsg, errStatusCode: $errStatusCode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountAvailabilityState &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.errMsg, errMsg) &&
            const DeepCollectionEquality()
                .equals(other.errStatusCode, errStatusCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(errMsg),
      const DeepCollectionEquality().hash(errStatusCode));

  @JsonKey(ignore: true)
  @override
  _$AccountAvailabilityStateCopyWith<_AccountAvailabilityState> get copyWith =>
      __$AccountAvailabilityStateCopyWithImpl<_AccountAvailabilityState>(
          this, _$identity);
}

abstract class _AccountAvailabilityState implements AccountAvailabilityState {
  const factory _AccountAvailabilityState(
      {dynamic status,
      String? errMsg,
      int? errStatusCode}) = _$_AccountAvailabilityState;

  @override
  dynamic get status;
  @override
  String? get errMsg;
  @override
  int? get errStatusCode;
  @override
  @JsonKey(ignore: true)
  _$AccountAvailabilityStateCopyWith<_AccountAvailabilityState> get copyWith =>
      throw _privateConstructorUsedError;
}
