import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/services/device/uuid_device_fingerprint_provider.dart';
import 'package:uuid/uuid.dart';

class MockUuidPlugin extends Mock implements Uuid {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('UuidDeviceFingerprintProvider', () {
    late Uuid uuidPlugin;
    late SharedPreferences sharedPreferences;
    late UuidDeviceFingerprintProvider fingerprintProvider;

    const mockUuid = 'version-4-uuid';

    setUpAll(() {
      uuidPlugin = MockUuidPlugin();
      when(() => uuidPlugin.v4()).thenReturn(mockUuid);

      sharedPreferences = MockSharedPreferences();

      fingerprintProvider = UuidDeviceFingerprintProvider(
        uuidPlugin,
        sharedPreferences,
      );
    });

    group(
      '[getFingerprint()]',
      () {
        test(
          'tries to retrieve a fingerprint stored in SharedPreferences. If not '
          'found, it creates a new fingerprint using [Uuid.v4()] and saves it into '
          'SharedPreferences.',
          () async {
            // Simulate no fingerprint saved in device
            when(
              () => sharedPreferences.getString(
                UuidDeviceFingerprintProvider.kPrefsFakeFingerprint,
              ),
            ).thenAnswer((_) => null);

            when(
              () => sharedPreferences.setString(
                UuidDeviceFingerprintProvider.kPrefsFakeFingerprint,
                any(),
              ),
            ).thenAnswer((_) async => true);

            final fingerprint = await fingerprintProvider.getFingerprint();

            // Verifies a UUID v4 is generated and saved into SharedPreferences
            verify(() => uuidPlugin.v4()).called(1);
            verify(
              () => sharedPreferences.getString(
                UuidDeviceFingerprintProvider.kPrefsFakeFingerprint,
              ),
            ).called(1);
            verify(
              () => sharedPreferences.setString(
                UuidDeviceFingerprintProvider.kPrefsFakeFingerprint,
                mockUuid,
              ),
            ).called(1);

            expect(fingerprint, mockUuid);
          },
        );

        test(
          'uses saved fingerprint in SharedPreferences if available',
          () async {
            // Simulate saved fingerprint is available
            when(
              () => sharedPreferences.getString(
                UuidDeviceFingerprintProvider.kPrefsFakeFingerprint,
              ),
            ).thenAnswer((_) => mockUuid);

            final fingerprint = await fingerprintProvider.getFingerprint();

            expect(fingerprint, mockUuid);
          },
        );
      },
    );
  });
}
