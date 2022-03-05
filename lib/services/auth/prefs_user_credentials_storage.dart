import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/constants/prefs_keys.dart';
import 'package:storefront_app/domain/auth/user_credentials.dart';
import 'package:storefront_app/services/auth/user_credentials_storage.dart';

/// Uses [SharedPreferences] as underlying storage mechanism.
///
/// Supports caching [UserCredentials] in memory to avoid I/O calls to
/// local storage.
class PrefsUserCredentialsStorage extends UserCredentialsStorage {
  PrefsUserCredentialsStorage(this.prefs);

  @visibleForTesting
  final SharedPreferences prefs;

  UserCredentials? creds;
  bool credsIsCached = false;

  /// Fetches user token and phone number from [SharedPreferences]
  ///
  /// Once this method is called, value will be stored in memory in [creds] and
  /// will no longer read from [SharedPreferences]
  @override
  Future<UserCredentials?> getCredentials() async {
    if (credsIsCached) return creds;

    final token = prefs.getString(PrefsKeys.kUserAuthToken);
    final phoneNumber = prefs.getString(PrefsKeys.kUserPhoneNumber);

    creds = token == null
        ? null
        : UserCredentials(authToken: token, phoneNumber: phoneNumber!);

    credsIsCached = true;

    return creds;
  }

  @override
  Future<void> persistCredentials(String authToken, String phoneNumber) async {
    prefs.setString(PrefsKeys.kUserAuthToken, authToken);
    prefs.setString(PrefsKeys.kUserPhoneNumber, phoneNumber);

    creds = UserCredentials(authToken: authToken, phoneNumber: phoneNumber);
    credsIsCached = true;
  }

  @override
  void unpersistCredentials() {
    prefs.remove(PrefsKeys.kUserAuthToken);
    prefs.remove(PrefsKeys.kUserPhoneNumber);

    creds = null;
    credsIsCached = true;
  }
}
