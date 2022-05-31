import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/core/services/device/fpjs_provider.dart';

import '../../src/mock_customer_service_client.dart';

class MockFpJsProPluginWrapper extends Mock implements FpJsProPluginWrapper {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('FingerprintJSProvider', () {
    late FpJsProPluginWrapper wrapper;
    late IPrefsRepository sharedPreferences;
    late FingerPrintJsProvider fingerprintProvider;

    const mockfpjsId = 'finger-print-js-mock-id';

    setUp(() {
      wrapper = MockFpJsProPluginWrapper();
      sharedPreferences = MockIPrefsRepository();
      fingerprintProvider = FingerPrintJsProvider(
        wrapper: wrapper,
        sharedPreferences: sharedPreferences,
      );
    });

    group(
      '[getFingerprint()]',
      () {
        test(
          'should create new fingerprint and save it '
          'when no finger print exist in SharedPreference database',
          () async {
            // Simulate no fingerprint saved in device
            when(
              () => sharedPreferences.getFingerPrint(),
            ).thenAnswer((_) async => null);

            when(
              () => sharedPreferences.setFingerPrint(any()),
            ).thenAnswer((_) async => true);

            when(() => wrapper()).thenAnswer((_) async => mockfpjsId);

            final fingerprint = await fingerprintProvider.getFingerprint();

            // Verifies a device id is generated and saved into SharedPreferences
            verify(() => wrapper()).called(1);
            verify(
              () => sharedPreferences.getFingerPrint(),
            ).called(1);
            verify(
              () => sharedPreferences.setFingerPrint(mockfpjsId),
            ).called(1);

            expect(fingerprint, mockfpjsId);
          },
        );

        test(
          'uses saved fingerprint in SharedPreferences if available',
          () async {
            // Simulate saved fingerprint is available
            when(
              () => sharedPreferences.getFingerPrint(),
            ).thenAnswer((_) async => mockfpjsId);

            final fingerprint = await fingerprintProvider.getFingerprint();

            expect(fingerprint, mockfpjsId);
          },
        );
      },
    );
  });
}
