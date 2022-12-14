import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/phone_verification_result.dart';
import 'auth_service.dart';
import 'firebase_auth_exception_codes.dart';

// TODO (leovinsen): refactor and handle errors with Failure
/// Uses [FirebaseAuth] to handle authentication process.
///
/// Call [initialize] once when app is first created to start
/// listening to [FirebaseAuth.authStateChanges].
///
/// On receiving a new event, it will trigger [onFirebaseUserChanged] which
/// persists or unpersists user information using [UserCredentialsStorage].
class FirebaseAuthService extends AuthService {
  FirebaseAuthService({
    required this.firebaseAuth,
    required this.otpTimeoutInSeconds,
  }) : super() {
    _subscriptionFirebaseUserChanges =
        firebaseAuth.authStateChanges().listen(onFirebaseUserChanged);
  }

  final FirebaseAuth firebaseAuth;
  final int otpTimeoutInSeconds;

  late StreamSubscription<User?> _subscriptionFirebaseUserChanges;
  int? _resendToken;
  String? _verificationId;

  /// Persists a [UserCredentials] when [user] is not null, otherwise
  /// unpersists existing information from storage.
  ///
  /// [user] will be null when user is not logged in when app is first opened
  /// or when user triggers a sign out event.
  @visibleForTesting
  Future<void> onFirebaseUserChanged(User? user) async {
    // TODO (leovinsen): Implement a new Stream for user changes
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: _resendToken,
      verificationCompleted: tryFirebaseSignIn,
      verificationFailed: handleFirebaseExceptions,
      codeSent: onSmsCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {
        // TODO (leovinsen): Unsure how to handle this case
        // Based on the docs the verificationId doesn't seem
        // to be changed, but just in case let's update the verificationId

        verificationId = verificationId;
      },
      timeout: Duration(seconds: otpTimeoutInSeconds),
    );
  }

  @visibleForTesting
  void onSmsCodeSent(String verificationId, int? resendToken) {
    _verificationId = verificationId;
    _resendToken = resendToken;

    addToPhoneVerificationStream(
      PhoneVerificationResult(status: PhoneVerificationStatus.otpSent),
    );
  }

  @override
  Future<void> verifyOtp(String otp) async {
    final AuthCredential creds = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    await tryFirebaseSignIn(creds);
  }

  @visibleForTesting
  Future<void> tryFirebaseSignIn(AuthCredential credential) async {
    try {
      await firebaseAuth.signInWithCredential(credential);

      final result = PhoneVerificationResult(
        status: PhoneVerificationStatus.verifiedSuccessfully,
      );
      addToPhoneVerificationStream(result);
    } on FirebaseAuthException catch (e) {
      handleFirebaseExceptions(e);
    } catch (e) {
      addToPhoneVerificationStream(PhoneVerificationResult.error(e.toString()));
    }
  }

  /// Map [FirebaseAuthException] to more meaningful error messages
  @visibleForTesting
  void handleFirebaseExceptions(FirebaseAuthException exception) {
    late String errMsg;
    PhoneVerificationStatus status = PhoneVerificationStatus.error;

    switch (exception.code) {
      case FirebaseAuthExceptionCodes.invalidPhoneNumber:
        errMsg = 'Nomor handphone yang digunakan tidak valid!';
        break;
      case FirebaseAuthExceptionCodes.invalidPhoneVerificationCode:
      case FirebaseAuthExceptionCodes.invalidPhoneVerificationId:
        status = PhoneVerificationStatus.invalidOtp;
        errMsg = 'OTP tidak valid!';
        break;
      case FirebaseAuthExceptionCodes.userDisabled:
        errMsg = 'Akun tidak dapat diakses!';
        break;
      // TODO (leovinsen): 'Operation Not Allowed' should not be shown to user
      // but should be escalated to development team e.g. through logging
      case FirebaseAuthExceptionCodes.operationNotAllowed:
      default:
        // Other error codes which in theory should not occur e.g. related to
        // email or social logins.
        errMsg = 'Proses verifikasi gagal; mohon coba kembali';
        break;
    }

    final result = PhoneVerificationResult(
      status: status,
      exception: PhoneVerificationException(errMsg),
    );

    addToPhoneVerificationStream(result);
  }

  @override
  void dispose() {
    _subscriptionFirebaseUserChanges.cancel();
    super.dispose();
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// Returns an auth token if user has successfully signed in
  /// with Firebase Auth.
  /// Otherwise returns [null].
  @override
  Future<String?> getToken() async {
    // TODO (leovinsen): Implement retry backoff
    try {
      return firebaseAuth.currentUser?.getIdToken();
    } catch (e) {
      return null;
    }
  }
}
