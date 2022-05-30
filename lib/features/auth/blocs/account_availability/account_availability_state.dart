part of 'account_availability_cubit.dart';

abstract class AccountAvailabilityState extends Equatable {
  const AccountAvailabilityState();

  @override
  List<Object?> get props => [];
}

/// Initial state when [AccountAvailabilityCubit] is first instantiated.
class AccountAvailabilityInitial extends AccountAvailabilityState {
  const AccountAvailabilityInitial();
}

/// When [AccountAvailabilityCubit] is checking account
/// availiability against backend.
class AccountAvailabilityLoading extends AccountAvailabilityState {
  const AccountAvailabilityLoading();
}

/// When phone number being verified against backend
/// is not yet used by any user in Dropezy.
class PhoneIsAvailable extends AccountAvailabilityState {
  const PhoneIsAvailable();
}

/// When phone number being verified against backend
/// is already used by another user in Dropezy.
class PhoneIsAlreadyRegistered extends AccountAvailabilityState {
  const PhoneIsAlreadyRegistered();
}

/// When a failure occured during verification process.
class AccountAvailabilityError extends AccountAvailabilityState {
  final String errorMsg;

  const AccountAvailabilityError(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}
