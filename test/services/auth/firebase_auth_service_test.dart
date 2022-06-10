import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/auth/domain/repository/phone_verification_result.dart';
import 'package:storefront_app/features/auth/domain/services/firebase_auth_exception_codes.dart';
import 'package:storefront_app/features/auth/domain/services/firebase_auth_service.dart';
import 'package:storefront_app/features/auth/domain/services/user_credentials_storage.dart';

class MockUser extends Mock implements User {}

class MockUserCredentialsStorage extends Mock
    implements UserCredentialsStorage {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('Firebase Auth Service', () {
    late FirebaseAuthService service;
    late UserCredentialsStorage credentialsStorage;
    late FirebaseAuth firebaseAuth;

    const mockToken = '1234';
    const mockPhoneNumber = '+6281234567890';

    setUp(() async {
      credentialsStorage = MockUserCredentialsStorage();
      firebaseAuth = MockFirebaseAuth();

      //  Always return an empty stream
      when(() => firebaseAuth.authStateChanges())
          .thenAnswer((_) => const Stream.empty());

      service = FirebaseAuthService(
        credentialsStorage: credentialsStorage,
        firebaseAuth: firebaseAuth,
        otpTimeoutInSeconds: 10,
      );
    });

    test(
      'should call [UserCredentialsStorage.signOutApps()] and [ FirebaseAuth.instance.signOut()] '
      'when [FirebaseAuthService.signOut] is called',
      () async {
        when(() => credentialsStorage.signOutApps()).thenAnswer((_) async {});
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

        await service.signOut();

        verify(() => credentialsStorage.signOutApps()).called(1);
        verify(() => firebaseAuth.signOut()).called(1);
      },
    );

    group('[onFirebaseUserChanged()]', () {
      test(
        'Calls [UserCredentialsStorage.unpersistCredentials()] if user is null',
        () async {
          when(() => credentialsStorage.unpersistCredentials())
              .thenAnswer((_) async {});

          await service.onFirebaseUserChanged(null);

          verify(() => credentialsStorage.unpersistCredentials()).called(1);
          verifyNever(
            () => credentialsStorage.persistCredentials(any(), any()),
          );
        },
      );

      test(
        'Calls [UserCredentialsStorage.persistCredentials()] if user is not null',
        () async {
          when(() => credentialsStorage.persistCredentials(any(), any()))
              .thenAnswer((_) async {});

          /// Mock a Firebase User and use [mockToken] and [mockPhoneNumber]
          final user = MockUser();
          when(() => user.getIdToken()).thenAnswer((_) async => mockToken);
          when(() => user.phoneNumber).thenReturn(mockPhoneNumber);

          await service.onFirebaseUserChanged(user);

          verify(() => credentialsStorage.persistCredentials(any(), any()))
              .called(1);
          verifyNever(() => credentialsStorage.unpersistCredentials());
        },
      );
    });

    test(
      '[sendOtp()] should call [FirebaseAuth.verifyPhoneNumber()] with '
      'specified phone number and callbacks',
      () async {
        when(
          () => firebaseAuth.verifyPhoneNumber(
            phoneNumber: mockPhoneNumber,
            verificationCompleted: service.tryFirebaseSignIn,
            verificationFailed: service.handleFirebaseExceptions,
            codeSent: service.onSmsCodeSent,
            codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
            timeout: Duration(seconds: service.otpTimeoutInSeconds),
          ),
        ).thenAnswer((_) async {});

        await service.sendOtp(mockPhoneNumber);

        verify(
          () => firebaseAuth.verifyPhoneNumber(
            phoneNumber: mockPhoneNumber,
            verificationCompleted: service.tryFirebaseSignIn,
            verificationFailed: service.handleFirebaseExceptions,
            codeSent: service.onSmsCodeSent,
            codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
            timeout: Duration(seconds: service.otpTimeoutInSeconds),
          ),
        ).called(1);
      },
    );

    group('[tryFirebaseSignIn()]', () {
      test(
        'should call [FirebaseAuth.signInWithCredential]',
        () async {
          final AuthCredential creds = PhoneAuthProvider.credential(
            verificationId: '123',
            smsCode: '123456',
          );
          when(() => firebaseAuth.signInWithCredential(creds))
              .thenAnswer((_) async => any());

          await service.tryFirebaseSignIn(creds);

          verify(() => firebaseAuth.signInWithCredential(creds)).called(1);
        },
      );

      test(
        'test exception handling for [FirebaseAuth.signInWithCredential]',
        () async {
          final expectedErrorFirebaseAuth = PhoneVerificationResult(
            status: PhoneVerificationStatus.error,
            exception: const PhoneVerificationException(
              'Nomor handphone yang digunakan tidak valid!',
            ),
          );

          final expectedErrorOthers = PhoneVerificationResult(
            status: PhoneVerificationStatus.error,
            exception:
                const PhoneVerificationException('Exception: Dummy Error'),
          );

          // Expect two errors to be handled
          expectLater(
            service.phoneVerificationStream,
            emitsInOrder([expectedErrorFirebaseAuth, expectedErrorOthers]),
          );

          final AuthCredential creds = PhoneAuthProvider.credential(
            verificationId: '123',
            smsCode: '123456',
          );

          // Throw FirebaseAuthException
          when(() => firebaseAuth.signInWithCredential(creds)).thenThrow(
            FirebaseAuthException(
              code: FirebaseAuthExceptionCodes.invalidPhoneNumber,
            ),
          );

          await service.tryFirebaseSignIn(creds);

          // Throw other exception
          when(() => firebaseAuth.signInWithCredential(creds))
              .thenThrow(Exception('Dummy Error'));

          await service.tryFirebaseSignIn(creds);
        },
      );
    });
  });
}
