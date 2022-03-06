part of 'phone_verification_result.dart';

class PhoneVerificationException implements Exception {
  final String errorMessage;

  const PhoneVerificationException(this.errorMessage);

  @override
  String toString() => 'PhoneVerificationException: $errorMessage';
}
