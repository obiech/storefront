import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/auth/phone_verification_result.dart';
import '../../domain/auth/user_credentials.dart';
import 'auth_service.dart';
import 'firebase_auth_exception_codes.dart';

class FirebaseAuthService extends AuthService {
  FirebaseAuthService({
    required this.firebaseAuth,
    required this.otpTimeoutInSeconds,
  });

  final FirebaseAuth firebaseAuth;
  final int otpTimeoutInSeconds;

  int? _resendToken;
  String? _verificationId;

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: _resendToken,
      verificationCompleted: _tryFirebaseSignIn,
      verificationFailed: _handleFirebaseExceptions,
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        resendToken = resendToken;

        addToPhoneVerificationStream(
            PhoneVerificationResult(status: PhoneVerificationStatus.otpSent));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // TODO (leovinsen): Unsure how to handle this case
        // Based on the docs the verificationId doesn't seem
        // to be changed, but just in case let's update the verificationId

        verificationId = verificationId;
      },
      timeout: Duration(seconds: otpTimeoutInSeconds),
    );
  }

  @override
  Future<void> verifyOtp(String otp) async {
    AuthCredential creds = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    await _tryFirebaseSignIn(creds);
  }

  Future<void> _tryFirebaseSignIn(AuthCredential credential) async {
    try {
      await firebaseAuth.signInWithCredential(credential);

      final result = PhoneVerificationResult(
          status: PhoneVerificationStatus.verifiedSuccessfully);
      addToPhoneVerificationStream(result);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseExceptions(e);
    } catch (e) {
      addToPhoneVerificationStream(PhoneVerificationResult.error(e.toString()));
    }
  }

  /// Map [FirebaseAuthException] to more meaningful error messages
  void _handleFirebaseExceptions(FirebaseAuthException exception) {
    late String errMsg;
    PhoneVerificationStatus status = PhoneVerificationStatus.error;

    switch (exception.code) {
      case FirebaseAuthExceptionCodes.invalidPhoneNumber:
        errMsg = "Nomor handphone yang digunakan tidak valid!";
        break;
      case FirebaseAuthExceptionCodes.invalidPhoneVerificationCode:
      case FirebaseAuthExceptionCodes.invalidPhoneVerificationId:
        status = PhoneVerificationStatus.invalidOtp;
        errMsg = "OTP tidak valid!";
        break;
      case FirebaseAuthExceptionCodes.userDisabled:
        errMsg = "Akun tidak dapat diakses!";
        break;
      // TODO (leovinsen): 'Operation Not Allowed' should not be shown to user
      // but should be escalated to development team e.g. through logging
      case FirebaseAuthExceptionCodes.operationNotAllowed:
      default:
        // Other error codes which in theory should not occur e.g. related to
        // email or social logins.
        errMsg = "Proses verifikasi gagal; mohon coba kembali";
        break;
    }

    final result = PhoneVerificationResult(
      status: status,
      exception: PhoneVerificationException(errMsg),
    );

    addToPhoneVerificationStream(result);
  }

  @override
  Stream<UserCredentials?> get userCredentialChanges {
    return firebaseAuth.authStateChanges().asyncMap(
      (User? user) async {
        if (user == null) {
          // The user is signed out
          return null;
        } else {
          // The user is logged in
          return UserCredentials(authToken: await user.getIdToken());
        }
      },
    );
  }
}
