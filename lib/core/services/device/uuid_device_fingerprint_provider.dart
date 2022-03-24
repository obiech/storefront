import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../prefs/i_prefs_repository.dart';
import 'device_fingerprint_provider.dart';

/// Generate Fingerprint for Device by creating a UUID.
///
/// Only used in development while waiting for FingerprintJS.
@LazySingleton(as: DeviceFingerprintProvider)
class UuidDeviceFingerprintProvider extends DeviceFingerprintProvider {
  UuidDeviceFingerprintProvider(this.uuid, this.sharedPreferences);

  static const kPrefsFakeFingerprint = 'fakeDeviceFingerprint';

  final Uuid uuid;
  final IPrefsRepository sharedPreferences;

  @override
  Future<String> getFingerprint() async {
    final savedFingerprint = await sharedPreferences.getFingerPrint();

    if (savedFingerprint != null) {
      return savedFingerprint;
    }

    final newFingerprint = uuid.v4();

    sharedPreferences.setFingerPrint(newFingerprint);
    return newFingerprint;
  }
}
