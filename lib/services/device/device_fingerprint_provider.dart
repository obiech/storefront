/// Is responsible for generating a unique identifier (fingerprint)
/// for the current device.
abstract class DeviceFingerprintProvider {
  Future<String> getFingerprint();
}
