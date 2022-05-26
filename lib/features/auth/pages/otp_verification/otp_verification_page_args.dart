import 'package:freezed_annotation/freezed_annotation.dart';

import 'otp_success_action.dart';
import 'otp_verification_page.dart';

part 'otp_verification_page_args.freezed.dart';

/// Arguments for [OtpVerificationPage] when pushing its route
///
/// [phoneNumberIntlFormat] is phone number prefixed with calling country code
/// [successAction] is the action to be taken after successful verification
@freezed
class OtpVerificationPageArgs with _$OtpVerificationPageArgs {
  const factory OtpVerificationPageArgs({
    required String phoneNumberIntlFormat,
    required OtpSuccessAction successAction,
    @Default(false) bool registerAccountAfterSuccessfulOtp,
  }) = _OtpVerificationPageArgs;
}
