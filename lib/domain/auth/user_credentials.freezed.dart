// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$UserCredentialsTearOff {
  const _$UserCredentialsTearOff();

  _UserCredentials call({required String authToken}) {
    return _UserCredentials(
      authToken: authToken,
    );
  }
}

/// @nodoc
const $UserCredentials = _$UserCredentialsTearOff();

/// @nodoc
mixin _$UserCredentials {
  String get authToken => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCredentialsCopyWith<UserCredentials> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCredentialsCopyWith<$Res> {
  factory $UserCredentialsCopyWith(
          UserCredentials value, $Res Function(UserCredentials) then) =
      _$UserCredentialsCopyWithImpl<$Res>;
  $Res call({String authToken});
}

/// @nodoc
class _$UserCredentialsCopyWithImpl<$Res>
    implements $UserCredentialsCopyWith<$Res> {
  _$UserCredentialsCopyWithImpl(this._value, this._then);

  final UserCredentials _value;
  // ignore: unused_field
  final $Res Function(UserCredentials) _then;

  @override
  $Res call({
    Object? authToken = freezed,
  }) {
    return _then(_value.copyWith(
      authToken: authToken == freezed
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$UserCredentialsCopyWith<$Res>
    implements $UserCredentialsCopyWith<$Res> {
  factory _$UserCredentialsCopyWith(
          _UserCredentials value, $Res Function(_UserCredentials) then) =
      __$UserCredentialsCopyWithImpl<$Res>;
  @override
  $Res call({String authToken});
}

/// @nodoc
class __$UserCredentialsCopyWithImpl<$Res>
    extends _$UserCredentialsCopyWithImpl<$Res>
    implements _$UserCredentialsCopyWith<$Res> {
  __$UserCredentialsCopyWithImpl(
      _UserCredentials _value, $Res Function(_UserCredentials) _then)
      : super(_value, (v) => _then(v as _UserCredentials));

  @override
  _UserCredentials get _value => super._value as _UserCredentials;

  @override
  $Res call({
    Object? authToken = freezed,
  }) {
    return _then(_UserCredentials(
      authToken: authToken == freezed
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_UserCredentials implements _UserCredentials {
  const _$_UserCredentials({required this.authToken});

  @override
  final String authToken;

  @override
  String toString() {
    return 'UserCredentials(authToken: $authToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserCredentials &&
            const DeepCollectionEquality().equals(other.authToken, authToken));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(authToken));

  @JsonKey(ignore: true)
  @override
  _$UserCredentialsCopyWith<_UserCredentials> get copyWith =>
      __$UserCredentialsCopyWithImpl<_UserCredentials>(this, _$identity);
}

abstract class _UserCredentials implements UserCredentials {
  const factory _UserCredentials({required String authToken}) =
      _$_UserCredentials;

  @override
  String get authToken;
  @override
  @JsonKey(ignore: true)
  _$UserCredentialsCopyWith<_UserCredentials> get copyWith =>
      throw _privateConstructorUsedError;
}
