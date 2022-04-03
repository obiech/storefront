import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/core/core.dart';
import 'package:uuid/uuid.dart';

import '../../src/mock_customer_service_client.dart';

class MockUuidPlugin extends Mock implements Uuid {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('UuidDeviceFingerprintProvider', () {
    late Uuid uuidPlugin;
    late IPrefsRepository sharedPreferences;
    late UuidDeviceFingerprintProvider fingerprintProvider;

    const mockUuid = 'version-4-uuid';

    setUp(() {
      uuidPlugin = MockUuidPlugin();
      sharedPreferences = MockIPrefsRepository();
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
              () => sharedPreferences.getFingerPrint(),
            ).thenAnswer((_) async => null);

            when(
              () => sharedPreferences.setFingerPrint(any()),
            ).thenAnswer((_) async => true);

            when(() => uuidPlugin.v4()).thenReturn(mockUuid);

            final fingerprint = await fingerprintProvider.getFingerprint();

            // Verifies a UUID v4 is generated and saved into SharedPreferences
            verify(() => uuidPlugin.v4()).called(1);
            verify(
              () => sharedPreferences.getFingerPrint(),
            ).called(1);
            verify(
              () => sharedPreferences.setFingerPrint(mockUuid),
            ).called(1);

            expect(fingerprint, mockUuid);
          },
        );

        test(
          'uses saved fingerprint in SharedPreferences if available',
          () async {
            // Simulate saved fingerprint is available
            when(
              () => sharedPreferences.getFingerPrint(),
            ).thenAnswer((_) async => mockUuid);

            final fingerprint = await fingerprintProvider.getFingerprint();

            expect(fingerprint, mockUuid);
          },
        );
      },
    );
  });
}
