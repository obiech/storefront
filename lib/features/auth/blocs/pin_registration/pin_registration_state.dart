part of 'pin_registration_cubit.dart';

abstract class PinRegistrationState extends Equatable {
  const PinRegistrationState();

  @override
  List<Object?> get props => [];
}

/// Initial state when [PinRegistrationCubit] is first initialized.
class PinRegistrationInitial extends PinRegistrationState {
  const PinRegistrationInitial();
}

/// When waiting for PIN to be registered.
class PinRegistrationLoading extends PinRegistrationState {
  const PinRegistrationLoading();
}

/// When PIN is successfully registered.
class PinRegistrationSuccess extends PinRegistrationState {
  const PinRegistrationSuccess();
}

/// When an error occured during PiN registration process.
class PinRegistrationError extends PinRegistrationState {
  const PinRegistrationError(this.errorMsg);

  final String errorMsg;

  @override
  List<Object?> get props => [errorMsg];
}
