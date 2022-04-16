import 'package:shared_preferences/shared_preferences.dart';

/// When interacting with [SharedPreferences], please try to use
/// the constants provided here to avoid typos and to easily find
/// functions that depend on a particular Key.
///
/// The actual value can be anything, but it is encouraged to pick a name
/// that fits the Key's purpose
class PrefsKeys {
  static const kIsOnboarded = 'isOnboarded';
  static const kUserAuthToken = 'userAuthToken';
  static const kUserPhoneNumber = 'userPhoneNumber';
  static const kDeviceFingerPrint = 'fakeDeviceFingerprint';
  static const kSearchQueries = 'kSearchQueries';
}
