import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/auth/phone_verification_result.dart';
import 'user_credentials_storage.dart';

/// Contract for describing a Service that deals with Authentication.
///
/// Currently supports only phone authentication.
///
/// Phone verification progress is monitored using a [Stream] instead of
/// [Future]s as the underlying implementation may not immediately return
/// the current progress status.
///
/// Subscribers of [_phoneVerificationStreamController] should expect
/// events to contain:
/// - [PhoneVerificationStatus.otpSent] after an OTP is sent
/// - [PhoneVerificationStatus.verifiedSuccessfully] once phone number is verified
/// - [PhoneVerificationStatus.error] if there are any errors
abstract class AuthService {
  AuthService(this.storage);

  @protected
  final UserCredentialsStorage storage;

  final _phoneVerificationStreamController =
      StreamController<PhoneVerificationResult>.broadcast();

  Stream<PhoneVerificationResult> get phoneVerificationStream =>
      _phoneVerificationStreamController.stream;

  /// Sends an OTP to specified [phoneNumber]
  Future<void> sendOtp(String phoneNumber);

  /// Check submitted OTP against sent OTP
  Future<void> verifyOtp(String otp);

  @protected
  @visibleForTesting
  void addToPhoneVerificationStream(PhoneVerificationResult result) {
    _phoneVerificationStreamController.add(result);
  }

  /// Call this to release resources
  void dispose() {
    _phoneVerificationStreamController.close();
  }
}
