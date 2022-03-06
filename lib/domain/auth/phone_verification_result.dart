import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_status.dart';
part 'phone_verification_exception.dart';
part 'phone_verification_result.freezed.dart';

extension PhoneVerificationResultX on PhoneVerificationResult {
  bool get isOtpSent => status == PhoneVerificationStatus.otpSent;
  bool get isVerifiedSuccessfully =>
      status == PhoneVerificationStatus.verifiedSuccessfully;
  bool get isError => status == PhoneVerificationStatus.error;
}

@freezed
class PhoneVerificationResult with _$PhoneVerificationResult {
  /// exception must not be null when status == [PhoneVerificationStatus.error]
  @Assert('''status != PhoneVerificationStatus.error || 
 exception != null''')
  const factory PhoneVerificationResult({
    required PhoneVerificationStatus status,
    @Default(null) PhoneVerificationException? exception,
  }) = _PhoneVerificationResult;

  /// Create an instance of [PhoneVerificationResult] with
  /// - [status] of [PhoneVerificationStatus.error]
  /// - and [exception] containing [errorMsg]
  factory PhoneVerificationResult.error(String errorMsg) {
    return PhoneVerificationResult(
      status: PhoneVerificationStatus.error,
      exception: PhoneVerificationException(errorMsg),
    );
  }
}
