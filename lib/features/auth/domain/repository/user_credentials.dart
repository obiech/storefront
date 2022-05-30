import 'package:equatable/equatable.dart';

class UserCredentials extends Equatable {
  /// Firebase ID token that we obtain after user
  /// successfully signs in with their phone number. Will be used as
  /// bearer token to secure protected endpoint on storefront backend.
  final String authToken;

  /// user's phone number
  final String phoneNumber;

  const UserCredentials({
    required this.authToken,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [authToken, phoneNumber];
}
