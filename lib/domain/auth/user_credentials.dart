import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_credentials.freezed.dart';

@freezed
class UserCredentials with _$UserCredentials {
  /// [authToken] is used to authenticate requests on behalf of this user
  /// e.g. JWTs or OAuth tokens
  const factory UserCredentials({
    required String authToken,
  }) = _UserCredentials;
}
