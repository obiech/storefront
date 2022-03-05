import 'dart:async';

import '../../domain/auth/user_credentials.dart';

/// Single source of truth for obtaining [UserCredentials] stored on device.
abstract class UserCredentialsStorage {
  /// Get currently stored [UserCredentials]. Returns [null] if not found.
  Future<UserCredentials?> getCredentials();

  /// Persist [UserCredentials] into storage.
  Future<void> persistCredentials(String authToken, String phoneNumber);

  /// Remove [UserCredentials] from storage.
  void unpersistCredentials();
}
