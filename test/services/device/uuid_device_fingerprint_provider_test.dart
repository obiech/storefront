import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/services/device/uuid_device_fingerprint_provider.dart';
import 'package:uuid/uuid.dart';

class MockUuidPlugin extends Mock implements Uuid {}

void main() {
  group('UuidDeviceFingerprintProvider', () {
    late Uuid uuidPlugin;
    late UuidDeviceFingerprintProvider fingerprintProvider;

    const mockUuid = 'version-4-uuid';

    setUpAll(() {
      uuidPlugin = MockUuidPlugin();
      when(() => uuidPlugin.v4()).thenReturn(mockUuid);

      fingerprintProvider = UuidDeviceFingerprintProvider(uuidPlugin);
    });
    test('[getFingerprint()] should call [Uuid.v4()]', () async {
      final fingerprint = await fingerprintProvider.getFingerprint();

      verify(() => uuidPlugin.v4()).called(1);
      expect(fingerprint, mockUuid);
    });
  });
}
