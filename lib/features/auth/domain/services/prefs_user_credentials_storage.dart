import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
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

  @visibleForTesting
  UserCredentials? creds;

  @visibleForTesting
  bool credsIsCached = false;

  /// Fetches user token and phone number from [SharedPreferences]
  ///
  /// Once this method is called, value will be stored in memory in [creds] and
  /// will no longer read from [SharedPreferences]
  @override
  UserCredentials? getCredentials() {
    if (credsIsCached) return creds;

    final token = prefs.userAuthToken();
    final phoneNumber = prefs.userPhoneNumber();

    creds = token == null
        ? null
        : UserCredentials(authToken: token, phoneNumber: phoneNumber!);

    credsIsCached = true;
    addToStream(creds);

    return creds;
  }

  @override
  Future<void> persistCredentials(String authToken, String phoneNumber) async {
    await prefs.setUserAuthToken(authToken);
    prefs.setUserPhoneNumber(phoneNumber);

    creds = UserCredentials(authToken: authToken, phoneNumber: phoneNumber);
    credsIsCached = true;
    addToStream(creds);
  }

  @override
  Future<void> unpersistCredentials() async {
    await prefs.clearUserAuthToken();
    await prefs.clearUserPhoneNumber();

    creds = null;
    credsIsCached = false;
    addToStream(creds);
  }
}
