import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/features/auth/domain/repository/user_credentials.dart';
import 'package:storefront_app/features/auth/domain/services/user_credentials_storage.dart';

import '../../../../core/services/prefs/i_prefs_repository.dart';

/// Uses [SharedPreferences] as underlying storage mechanism.
///
/// Supports caching [UserCredentials] in memory to avoid I/O calls to
/// local storage.
@LazySingleton(as: UserCredentialsStorage)
class PrefsUserCredentialsStorage extends UserCredentialsStorage {
  PrefsUserCredentialsStorage(this.prefs);

  @visibleForTesting
  final IPrefsRepository prefs;

  UserCredentials? creds;
  bool credsIsCached = false;

  /// Fetches user token and phone number from [SharedPreferences]
  ///
  /// Once this method is called, value will be stored in memory in [creds] and
  /// will no longer read from [SharedPreferences]
  @override
  Future<UserCredentials?> getCredentials() async {
    if (credsIsCached) return creds;

    final token = await prefs.userAuthToken();
    final phoneNumber = await prefs.userPhoneNumber();

    creds = token == null
        ? null
        : UserCredentials(authToken: token, phoneNumber: phoneNumber!);

    credsIsCached = true;

    return creds;
  }

  @override
  Future<void> persistCredentials(String authToken, String phoneNumber) async {
    await prefs.setUserAuthToken(authToken);
    prefs.setUserPhoneNumber(phoneNumber);

    creds = UserCredentials(authToken: authToken, phoneNumber: phoneNumber);
    credsIsCached = true;
  }

  @override
  Future<void> unpersistCredentials() async {
    await prefs.clearUserAuthToken();
    await prefs.clearUserPhoneNumber();

    creds = null;
    credsIsCached = false;
  }
}
