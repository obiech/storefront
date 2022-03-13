import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'device_fingerprint_provider.dart';

/// Generate Fingerprint for Device by creating a UUID.
///
/// Only used in development while waiting for FingerprintJS.
class UuidDeviceFingerprintProvider extends DeviceFingerprintProvider {
  UuidDeviceFingerprintProvider(this.uuid, this.sharedPreferences);

  static const kPrefsFakeFingerprint = 'fakeDeviceFingerprint';

  final Uuid uuid;
  final SharedPreferences sharedPreferences;

  @override
  Future<String> getFingerprint() async {
    final savedFingerprint = sharedPreferences.getString(kPrefsFakeFingerprint);

    if (savedFingerprint != null) {
      return savedFingerprint;
    }

    final newFingerprint = uuid.v4();

    sharedPreferences.setString(kPrefsFakeFingerprint, newFingerprint);
    return newFingerprint;
  }
}
