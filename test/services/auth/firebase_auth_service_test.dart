import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/auth/domain/repository/phone_verification_result.dart';
import 'package:storefront_app/features/auth/domain/services/firebase_auth_exception_codes.dart';
import 'package:storefront_app/features/auth/domain/services/firebase_auth_service.dart';

class MockUser extends Mock implements User {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('Firebase Auth Service', () {
    late FirebaseAuthService service;
    late FirebaseAuth firebaseAuth;

    const mockPhoneNumber = '+6281234567890';

    setUp(() async {
      firebaseAuth = MockFirebaseAuth();

      //  Always return an empty stream
      when(() => firebaseAuth.authStateChanges())
          .thenAnswer((_) => const Stream.empty());

      service = FirebaseAuthService(
        firebaseAuth: firebaseAuth,
        otpTimeoutInSeconds: 10,
      );
    });

    test(
      'should call [FirebaseAuth.instance.signOut()] '
      'when [FirebaseAuthService.signOut] is called',
      () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

        await service.signOut();

        verify(() => firebaseAuth.signOut()).called(1);
      },
    );

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

    test(
      'should retrieve token from [FirebaseAuth] [User] '
      'when [getToken()] is called '
      'and user is currently logged in',
      () async {
        // arrange
        final user = MockUser();
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => user.getIdToken()).thenAnswer((_) async => 'token-123');

        // act
        final token = await service.getToken();
        expect(token, 'token-123');

        // assert
        verify(() => firebaseAuth.currentUser?.getIdToken()).called(1);
      },
    );

    test(
      'should return null '
      'when [getToken()] is called '
      'and user is logged out',
      () async {
        // arrange
        when(() => firebaseAuth.currentUser).thenReturn(null);

        // act
        final token = await service.getToken();

        // assert
        expect(token, null);
        verify(() => firebaseAuth.currentUser?.getIdToken()).called(1);
      },
    );

    test(
      'should return null '
      'when [getToken()] is called '
      'and a [FirebaseAuthException] is thrown',
      () async {
        // arrange
        final user = MockUser();
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => user.getIdToken()).thenThrow(
          FirebaseAuthException(
            code: FirebaseAuthExceptionCodes.operationNotAllowed,
          ),
        );

        // act
        final token = await service.getToken();

        // assert
        expect(token, null);
        verify(() => firebaseAuth.currentUser?.getIdToken()).called(1);
      },
    );
  });
}
