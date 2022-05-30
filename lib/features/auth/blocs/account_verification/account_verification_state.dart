part of 'account_verification_cubit.dart';

abstract class AccountVerificationState extends Equatable {
  const AccountVerificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state when [AccountVerificationCubit] is first initialized.
class AccountVerificationInitial extends AccountVerificationState {
  const AccountVerificationInitial();
}

/// State when waiting for:
/// - OTP to be sent by Firebase
/// - OTP to be verified by Firebase
/// - Account to be registered with backend
class AccountVerificationLoading extends AccountVerificationState {
  const AccountVerificationLoading();
}

/// State after otp is sent by Firebase
/// and we are expecting user to input OTP.
class AccountVerificationOtpIsSent extends AccountVerificationState {
  const AccountVerificationOtpIsSent();
}

/// State after otp is successfuly verified by Firebase
/// and user's account is successfully registered with backend.
class AccountVerificationSuccess extends AccountVerificationState {
  const AccountVerificationSuccess();
}

/// State when Firebase returns an error due to invalid OTP.
class AccountVerificationInvalidOtp extends AccountVerificationState {
  const AccountVerificationInvalidOtp();
}

/// State when an unexpected failure is thrown.
class AccountVerificationError extends AccountVerificationState {
  const AccountVerificationError(this.errorMsg);

  final String errorMsg;

  @override
  List<Object?> get props => [errorMsg];
}
