import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../core.dart';

@LazySingleton(as: IPrefsRepository)
class PrefsRepository implements IPrefsRepository {
  final Box _prefBox;

  PrefsRepository(@Named(PREF_BOX) this._prefBox);

  @override
  String? userAuthToken() {
    return _prefBox.get(PrefsKeys.kUserAuthToken);
  }

  @override
  String? userPhoneNumber() {
    return _prefBox.get(PrefsKeys.kUserPhoneNumber);
  }

  @override
  Future<void> setUserAuthToken(String authToken) async {
    await _prefBox.put(PrefsKeys.kUserAuthToken, authToken);
  }

  @override
  Future<void> setUserPhoneNumber(String phoneNumber) async {
    await _prefBox.put(PrefsKeys.kUserPhoneNumber, phoneNumber);
  }

  @override
  Future<void> clearUserAuthToken() async {
    await _prefBox.delete(PrefsKeys.kUserAuthToken);
  }

  @override
  Future<void> clearUserPhoneNumber() async {
    await _prefBox.delete(PrefsKeys.kUserPhoneNumber);
  }

  @override
  Future<void> setFingerPrint(String fingerPrint) async {
    await _prefBox.put(PrefsKeys.kDeviceFingerPrint, fingerPrint);
  }

  @override
  String? getFingerPrint() {
    return _prefBox.get(PrefsKeys.kDeviceFingerPrint);
  }

  @override
  Future<void> clear() async {
    await _prefBox.clear();
  }

  @override
  Locale getDeviceLocale() {
    try {
      final _localeCode = _prefBox
          .get(PrefsKeys.kDeviceLocale, defaultValue: 'id-ID')
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
    await _prefBox.put(
      PrefsKeys.kDeviceLocale,
      locale.toLanguageTag(),
    );
  }
}
