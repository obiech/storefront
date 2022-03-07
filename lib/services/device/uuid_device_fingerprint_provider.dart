import 'package:uuid/uuid.dart';

import 'device_fingerprint_provider.dart';

/// Generate Fingerprint for Device by creating a UUID.
///
/// Only used in development while waiting for FingerprintJS.
class UuidDeviceFingerprintProvider extends DeviceFingerprintProvider {
  UuidDeviceFingerprintProvider(this.uuid);

  final Uuid uuid;

  @override
  Future<String> getFingerprint() async {
    return uuid.v4();
  }
}
