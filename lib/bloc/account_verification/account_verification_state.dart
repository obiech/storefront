import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_verification_state.freezed.dart';

enum AccountVerificationStatus {
  initialState,
  sendingOtp, // waiting for OTP to be sent by Firebase
  otpSent,
  verifyingOtp, // waiting for OTP to be verified by Firebase
  registeringAccount, // registering account with storefront backend
  success,
  invalidOtp,
  error
}

/// Convenience methods for checking State status
extension AccountVerificationStateX on AccountVerificationState {
  bool get isInitialState => status == AccountVerificationStatus.initialState;
  bool get isLoading => [
        AccountVerificationStatus.sendingOtp,
        AccountVerificationStatus.verifyingOtp,
        AccountVerificationStatus.registeringAccount,
      ].contains(status);
  bool get isOtpSent => status == AccountVerificationStatus.otpSent;
  bool get isSuccess => status == AccountVerificationStatus.success;
  bool get isInvalidOtp => status == AccountVerificationStatus.invalidOtp;
  bool get isOtherErrors => status == AccountVerificationStatus.error;
}

@freezed
class AccountVerificationState with _$AccountVerificationState {
  const factory AccountVerificationState({
    @Default(AccountVerificationStatus.initialState) status,
    String? errMsg,
  }) = _OtpVerificationState;
}
