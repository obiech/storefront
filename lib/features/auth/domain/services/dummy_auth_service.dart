import 'dart:async';

import 'package:storefront_app/core/core.dart';

import '../repository/phone_verification_result.dart';
import 'auth_service.dart';

/// DO NOT USE IN PRODUCTION
///
/// Dummy Auth Service that always return success for all operations.
/// Used for making authentication process easier in development environment.
class DummyAuthService extends AuthService {
  DummyAuthService(this._prefsRepository);

  final IPrefsRepository _prefsRepository;

  @override
  Future<void> sendOtp(String phoneNumber) async {
    addToPhoneVerificationStream(
      PhoneVerificationResult(status: PhoneVerificationStatus.otpSent),
    );
  }

  @override
  Future<void> verifyOtp(String otp) async {
    addToPhoneVerificationStream(
      PhoneVerificationResult(
        status: PhoneVerificationStatus.verifiedSuccessfully,
      ),
    );

    _prefsRepository.setUserAuthToken('token');
  }

  @override
  Future<void> signOut() async {
    await _prefsRepository.clear();
  }

  /// Returns 'token' as token.
  ///
  /// Works only when using storefront-backend in development
  @override
  Future<String?> getToken() async {
    return _prefsRepository.userAuthToken();
  }
}
