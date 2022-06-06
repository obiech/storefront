import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core.dart';

@LazySingleton(as: IPrefsRepository)
class PrefsRepository implements IPrefsRepository {
  final SharedPreferences _preferences;

  PrefsRepository(this._preferences);

  @override
  Future<bool> isOnBoarded() async {
    final _isOnBoarded = _preferences.getBool(PrefsKeys.kIsOnboarded);
    return _isOnBoarded ?? false;
  }

  @override
  Future<String?> userAuthToken() async {
    return _preferences.getString(PrefsKeys.kUserAuthToken);
  }

  @override
  Future<String?> userPhoneNumber() async {
    return _preferences.getString(PrefsKeys.kUserPhoneNumber);
  }

  @override
  Future<void> setUserAuthToken(String authToken) async {
    await _preferences.setString(PrefsKeys.kUserAuthToken, authToken);
  }

  @override
  Future<void> setUserPhoneNumber(String phoneNumber) async {
    await _preferences.setString(PrefsKeys.kUserPhoneNumber, phoneNumber);
  }

  @override
  Future<void> clearUserAuthToken() async {
    await _preferences.remove(PrefsKeys.kUserAuthToken);
  }

  @override
  Future<void> clearUserPhoneNumber() async {
    await _preferences.remove(PrefsKeys.kUserPhoneNumber);
  }

  @override
  Future<void> setFingerPrint(String fingerPrint) async {
    await _preferences.setString(PrefsKeys.kDeviceFingerPrint, fingerPrint);
  }

  @override
  Future<String?> getFingerPrint() async {
    return _preferences.getString(PrefsKeys.kDeviceFingerPrint);
  }

  @override
  Future<void> setIsOnBoarded(bool isOnBoarded) async {
    await _preferences.setBool(PrefsKeys.kIsOnboarded, isOnBoarded);
  }

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }

  @override
  Future<Locale> getDeviceLocale() async {
    try {
      final _localeCode =
          (_preferences.getString(PrefsKeys.kDeviceLocale) ?? 'id-ID')
              .split('-');

      return Locale.fromSubtags(
        languageCode: _localeCode.first,
        countryCode: _localeCode[1],
      );
    } catch (e) {
      return const Locale('id', 'ID');
    }
  }

  @override
  Future<void> setDeviceLocale(Locale locale) async {
    await _preferences.setString(
      PrefsKeys.kDeviceLocale,
      locale.toLanguageTag(),
    );
  }
}
