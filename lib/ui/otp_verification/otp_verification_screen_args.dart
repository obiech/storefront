import 'package:freezed_annotation/freezed_annotation.dart';

import 'otp_success_action.dart';
import 'otp_verification_screen.dart';

part 'otp_verification_screen_args.freezed.dart';

/// Arguments for [OtpVerificationScreen] when pushing its route
///
/// [phoneNumberIntlFormat] is phone number prefixed with calling country code
/// [successAction] is the action to be taken after successful verification
@freezed
class OtpVerificationScreenArgs with _$OtpVerificationScreenArgs {
  const factory OtpVerificationScreenArgs({
    required String phoneNumberIntlFormat,
    required OtpSuccessAction successAction,
  }) = _OtpVerificationScreenArgs;
}
