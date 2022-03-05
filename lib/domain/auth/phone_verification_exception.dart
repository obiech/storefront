part of 'phone_verification_result.dart';

class PhoneVerificationException implements Exception {
  final String errorMessage;

  const PhoneVerificationException(this.errorMessage);

  @override
  String toString() => 'PhoneVerificationException: $errorMessage';

  @override
  bool operator ==(Object other) =>
      other is PhoneVerificationException &&
      other.runtimeType == runtimeType &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;
}
