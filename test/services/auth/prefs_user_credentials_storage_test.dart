import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/core/services/prefs/i_prefs_repository.dart';
import 'package:storefront_app/features/auth/domain/repository/user_credentials.dart';
import 'package:storefront_app/features/auth/domain/services/prefs_user_credentials_storage.dart';

import '../../src/mock_customer_service_client.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Prefs User Credentials Storage', () {
    late PrefsUserCredentialsStorage credentialsStorage;
    late IPrefsRepository sharedPrefs;

    const mockToken = '1234';
    const mockPhoneNumber = '+6281234567890';

    setUp(() async {
      sharedPrefs = MockIPrefsRepository();
      credentialsStorage = PrefsUserCredentialsStorage(sharedPrefs);
    });

    group('[getCredentials()]', () {
      test(
        'should return UserCredentials if it exists in [SharedPreferences] '
        'and cache the result',
        () async {
          when(() => sharedPrefs.userAuthToken())
              .thenAnswer((_) async => mockToken);
          when(() => sharedPrefs.userPhoneNumber())
              .thenAnswer((_) async => mockPhoneNumber);

          const expectedCreds = UserCredentials(
            authToken: mockToken,
            phoneNumber: mockPhoneNumber,
          );

          // Cache should be empty
          expect(credentialsStorage.creds, null);
          expect(credentialsStorage.credsIsCached, false);

          // Test retrieving data from SharedPreferences
          final creds = await credentialsStorage.getCredentials();

          expect(creds, expectedCreds);
          expect(credentialsStorage.credsIsCached, true);
          verify(() => sharedPrefs.userAuthToken()).called(1);
          verify(() => sharedPrefs.userPhoneNumber()).called(1);

          // Test caching; should not hit SharedPreferences
          final cachedCreds = await credentialsStorage.getCredentials();

          expect(cachedCreds, expectedCreds);
          verifyNever(() => sharedPrefs.userAuthToken());
          verifyNever(() => sharedPrefs.userPhoneNumber());
        },
      );

      test(
        "should return null if [SharedPreferences] does not contain user's "
        'information',
        () async {
          when(() => sharedPrefs.userAuthToken()).thenAnswer(
            (_) async => null,
          );

          when(() => sharedPrefs.userPhoneNumber()).thenAnswer(
            (_) async => null,
          );

          const expectedCreds = null;

          // Cache should be empty
          expect(credentialsStorage.creds, null);
          expect(credentialsStorage.credsIsCached, false);

          // Test retrieving data from SharedPreferences
          final creds = await credentialsStorage.getCredentials();

          expect(creds, expectedCreds);
          expect(credentialsStorage.credsIsCached, true);
          verify(() => sharedPrefs.userAuthToken()).called(1);
          verify(() => sharedPrefs.userPhoneNumber()).called(1);
        },
      );
    });

    group('[persistCredentials()]', () {
      test(
        'should persist user token and phone number into [SharedPreferences] '
        'and update [UserCredentials] in cache',
        () async {
          when(() => sharedPrefs.setUserAuthToken(mockToken))
              .thenAnswer((_) async => true);
          when(
            () => sharedPrefs.setUserPhoneNumber(
              mockPhoneNumber,
            ),
          ).thenAnswer((_) async => true);

          // Initial state
          expect(credentialsStorage.creds, null);
          expect(credentialsStorage.credsIsCached, false);

          await credentialsStorage.persistCredentials(
            mockToken,
            mockPhoneNumber,
          );

          const expectedCreds = UserCredentials(
            authToken: mockToken,
            phoneNumber: mockPhoneNumber,
          );

          // cache should be updated, and values stored in [SharedPreferences]
          expect(credentialsStorage.creds, expectedCreds);
          expect(credentialsStorage.credsIsCached, true);

          verify(
            () => sharedPrefs.setUserAuthToken(mockToken),
          ).called(1);

          verify(
            () => sharedPrefs.setUserPhoneNumber(mockPhoneNumber),
          ).called(1);
        },
      );
    });

    group('[unpersistCredentials()]', () {
      test(
        'should remove user token and phone number from [SharedPreferences] '
        'and store [null] in cache',
        () async {
          when(() => sharedPrefs.clearUserAuthToken())
              .thenAnswer((_) async => true);
          when(() => sharedPrefs.clearUserPhoneNumber())
              .thenAnswer((_) async => true);

          // Initial state
          expect(credentialsStorage.credsIsCached, false);

          await credentialsStorage.unpersistCredentials();

          // Cache should be null, and keys removed from [SharedPreferences]
          expect(credentialsStorage.creds, null);
          expect(credentialsStorage.credsIsCached, false);
          verify(() => sharedPrefs.clearUserAuthToken()).called(1);
          verify(() => sharedPrefs.clearUserPhoneNumber()).called(1);
        },
      );
    });
  });
}
