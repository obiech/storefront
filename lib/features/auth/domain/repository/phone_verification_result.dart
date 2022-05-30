import 'package:equatable/equatable.dart';

part 'phone_verification_exception.dart';
part 'phone_verification_status.dart';

extension PhoneVerificationResultX on PhoneVerificationResult {
  bool get isOtpSent => status == PhoneVerificationStatus.otpSent;
  bool get isVerifiedSuccessfully =>
      status == PhoneVerificationStatus.verifiedSuccessfully;
  bool get isError => status == PhoneVerificationStatus.error;
}

class PhoneVerificationResult extends Equatable {
  /// exception must not be null when status == [PhoneVerificationStatus.error]
  const PhoneVerificationResult({
    required this.status,
    this.exception,
  }) : assert(status != PhoneVerificationStatus.error || exception != null);

  final PhoneVerificationStatus status;

  final PhoneVerificationException? exception;

  /// Create an instance of [PhoneVerificationResult] with
  /// - [status] of [PhoneVerificationStatus.error]
  /// - and [exception] containing [errorMsg]
  factory PhoneVerificationResult.error(String errorMsg) {
    return PhoneVerificationResult(
      status: PhoneVerificationStatus.error,
      exception: PhoneVerificationException(errorMsg),
    );
  }

  @override
  List<Object?> get props => [status, exception];
}
