import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/constants/prefs_keys.dart';
import 'package:storefront_app/domain/auth/user_credentials.dart';
import 'package:storefront_app/services/auth/prefs_user_credentials_storage.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Prefs User Credentials Storage', () {
    late PrefsUserCredentialsStorage credentialsStorage;
    late SharedPreferences sharedPrefs;

    const mockToken = '1234';
    const mockPhoneNumber = '+6281234567890';

    setUp(() async {
      sharedPrefs = MockSharedPreferences();
      credentialsStorage = PrefsUserCredentialsStorage(sharedPrefs);
    });

    group('[getCredentials()]', () {
      test(
        'should return UserCredentials if it exists in [SharedPreferences] '
        'and cache the result',
        () async {
          when(() => sharedPrefs.getString(PrefsKeys.kUserAuthToken))
              .thenReturn(mockToken);
          when(() => sharedPrefs.getString(PrefsKeys.kUserPhoneNumber))
              .thenReturn(mockPhoneNumber);

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
          verify(() => sharedPrefs.getString(PrefsKeys.kUserAuthToken))
              .called(1);
          verify(() => sharedPrefs.getString(PrefsKeys.kUserPhoneNumber))
              .called(1);

          // Test caching; should not hit SharedPreferences
          final cachedCreds = await credentialsStorage.getCredentials();

          expect(cachedCreds, expectedCreds);
          verifyNever(() => sharedPrefs.getString(PrefsKeys.kUserAuthToken));
          verifyNever(() => sharedPrefs.getString(PrefsKeys.kUserPhoneNumber));
        },
      );

      test(
        "should return null if [SharedPreferences] does not contain user's "
        'information',
        () async {
          when(() => sharedPrefs.getString(PrefsKeys.kUserAuthToken))
              .thenReturn(null);
          when(() => sharedPrefs.getString(PrefsKeys.kUserPhoneNumber))
              .thenReturn(null);

          const expectedCreds = null;

          // Cache should be empty
          expect(credentialsStorage.creds, null);
          expect(credentialsStorage.credsIsCached, false);

          // Test retrieving data from SharedPreferences
          final creds = await credentialsStorage.getCredentials();

          expect(creds, expectedCreds);
          expect(credentialsStorage.credsIsCached, true);
          verify(() => sharedPrefs.getString(PrefsKeys.kUserAuthToken))
              .called(1);
          verify(() => sharedPrefs.getString(PrefsKeys.kUserPhoneNumber))
              .called(1);
        },
      );
    });

    group('[persistCredentials()]', () {
      test(
        'should persist user token and phone number into [SharedPreferences] '
        'and update [UserCredentials] in cache',
        () async {
          when(() => sharedPrefs.setString(PrefsKeys.kUserAuthToken, mockToken))
              .thenAnswer((_) async => true);
          when(
            () => sharedPrefs.setString(
              PrefsKeys.kUserPhoneNumber,
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
            () => sharedPrefs.setString(PrefsKeys.kUserAuthToken, mockToken),
          ).called(1);

          verify(
            () => sharedPrefs.setString(
              PrefsKeys.kUserPhoneNumber,
              mockPhoneNumber,
            ),
          ).called(1);
        },
      );
    });

    group('[unpersistCredentials()]', () {
      test(
        'should remove user token and phone number from [SharedPreferences] '
        'and store [null] in cache',
        () async {
          when(() => sharedPrefs.remove(PrefsKeys.kUserAuthToken))
              .thenAnswer((_) async => true);
          when(() => sharedPrefs.remove(PrefsKeys.kUserPhoneNumber))
              .thenAnswer((_) async => true);

          // Initial state
          expect(credentialsStorage.credsIsCached, false);

          credentialsStorage.unpersistCredentials();

          // Cache should be null, and keys removed from [SharedPreferences]
          expect(credentialsStorage.creds, null);
          expect(credentialsStorage.credsIsCached, true);
          verify(() => sharedPrefs.remove(PrefsKeys.kUserAuthToken)).called(1);
          verify(() => sharedPrefs.remove(PrefsKeys.kUserPhoneNumber))
              .called(1);
        },
      );
    });
  });
}
