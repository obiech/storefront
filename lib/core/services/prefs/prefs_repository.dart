import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core.dart';

@LazySingleton(as: IPrefsRepository)
class PrefsRepository implements IPrefsRepository {
  late SharedPreferences _preferences;

  final _readyCompleter = Completer();

  Future get ready => _readyCompleter.future;

  PrefsRepository() {
    _init().then((_) {
      _readyCompleter.complete();
    });
  }

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<bool> isOnBoarded() async {
    await ready;
    final _isOnBoarded = _preferences.getBool(PrefsKeys.kIsOnboarded);
    return _isOnBoarded ?? false;
  }

  @override
  Future<String?> userAuthToken() async {
    await ready;
    return _preferences.getString(PrefsKeys.kUserAuthToken);
  }

  @override
  Future<String?> userPhoneNumber() async {
    await ready;
    return _preferences.getString(PrefsKeys.kUserPhoneNumber);
  }

  @override
  Future<void> setUserAuthToken(String authToken) async {
    await ready;
    await _preferences.setString(PrefsKeys.kUserAuthToken, authToken);
  }

  @override
  Future<void> setUserPhoneNumber(String phoneNumber) async {
    await ready;
    await _preferences.setString(PrefsKeys.kUserPhoneNumber, phoneNumber);
  }

  @override
  Future<void> clearUserAuthToken() async {
    await ready;
    await _preferences.remove(PrefsKeys.kUserAuthToken);
  }

  @override
  Future<void> clearUserPhoneNumber() async {
    await ready;
    await _preferences.remove(PrefsKeys.kUserPhoneNumber);
  }

  @override
  Future<void> setFingerPrint(String fingerPrint) async {
    await ready;
    await _preferences.setString(PrefsKeys.kDeviceFingerPrint, fingerPrint);
  }

  @override
  Future<String?> getFingerPrint() async {
    await ready;
    return _preferences.getString(PrefsKeys.kDeviceFingerPrint);
  }

  @override
  Future<void> setIsOnBoarded(bool isOnBoarded) async {
    await ready;
    await _preferences.setBool(PrefsKeys.kIsOnboarded, isOnBoarded);
  }
}
