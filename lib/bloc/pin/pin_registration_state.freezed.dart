// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pin_registration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PinRegistrationStateTearOff {
  const _$PinRegistrationStateTearOff();

  _PinRegistrationState call(
      {dynamic status = PinRegistrationStatus.initialState, String? errMsg}) {
    return _PinRegistrationState(
      status: status,
      errMsg: errMsg,
    );
  }
}

/// @nodoc
const $PinRegistrationState = _$PinRegistrationStateTearOff();

/// @nodoc
mixin _$PinRegistrationState {
  dynamic get status => throw _privateConstructorUsedError;
  String? get errMsg => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PinRegistrationStateCopyWith<PinRegistrationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinRegistrationStateCopyWith<$Res> {
  factory $PinRegistrationStateCopyWith(PinRegistrationState value,
          $Res Function(PinRegistrationState) then) =
      _$PinRegistrationStateCopyWithImpl<$Res>;
  $Res call({dynamic status, String? errMsg});
}

/// @nodoc
class _$PinRegistrationStateCopyWithImpl<$Res>
    implements $PinRegistrationStateCopyWith<$Res> {
  _$PinRegistrationStateCopyWithImpl(this._value, this._then);

  final PinRegistrationState _value;
  // ignore: unused_field
  final $Res Function(PinRegistrationState) _then;

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
abstract class _$PinRegistrationStateCopyWith<$Res>
    implements $PinRegistrationStateCopyWith<$Res> {
  factory _$PinRegistrationStateCopyWith(_PinRegistrationState value,
          $Res Function(_PinRegistrationState) then) =
      __$PinRegistrationStateCopyWithImpl<$Res>;
  @override
  $Res call({dynamic status, String? errMsg});
}

/// @nodoc
class __$PinRegistrationStateCopyWithImpl<$Res>
    extends _$PinRegistrationStateCopyWithImpl<$Res>
    implements _$PinRegistrationStateCopyWith<$Res> {
  __$PinRegistrationStateCopyWithImpl(
      _PinRegistrationState _value, $Res Function(_PinRegistrationState) _then)
      : super(_value, (v) => _then(v as _PinRegistrationState));

  @override
  _PinRegistrationState get _value => super._value as _PinRegistrationState;

  @override
  $Res call({
    Object? status = freezed,
    Object? errMsg = freezed,
  }) {
    return _then(_PinRegistrationState(
      status: status == freezed ? _value.status : status,
      errMsg: errMsg == freezed
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_PinRegistrationState implements _PinRegistrationState {
  const _$_PinRegistrationState(
      {this.status = PinRegistrationStatus.initialState, this.errMsg});

  @JsonKey()
  @override
  final dynamic status;
  @override
  final String? errMsg;

  @override
  String toString() {
    return 'PinRegistrationState(status: $status, errMsg: $errMsg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PinRegistrationState &&
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
  _$PinRegistrationStateCopyWith<_PinRegistrationState> get copyWith =>
      __$PinRegistrationStateCopyWithImpl<_PinRegistrationState>(
          this, _$identity);
}

abstract class _PinRegistrationState implements PinRegistrationState {
  const factory _PinRegistrationState({dynamic status, String? errMsg}) =
      _$_PinRegistrationState;

  @override
  dynamic get status;
  @override
  String? get errMsg;
  @override
  @JsonKey(ignore: true)
  _$PinRegistrationStateCopyWith<_PinRegistrationState> get copyWith =>
      throw _privateConstructorUsedError;
}
