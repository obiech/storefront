import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_credentials.freezed.dart';

@freezed
class UserCredentials with _$UserCredentials {
  /// - [authToken] is Firebase ID token that we obtain after user
  /// successfully signs in with their phone number. Will be used as
  /// bearer token to secure protected endpoint on storefront backend
  /// - [phoneNumber] is user's phone number
  const factory UserCredentials({
    required String authToken,
    required String phoneNumber,
  }) = _UserCredentials;
}
