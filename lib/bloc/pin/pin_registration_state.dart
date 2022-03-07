import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_registration_state.freezed.dart';

enum PinRegistrationStatus {
  initialState,
  success,
  loading,
  error, // other errors such as connection timeout
}

extension PinRegistrationStateX on PinRegistrationState {
  bool get isInitialState => status == PinRegistrationStatus.initialState;
  bool get isSuccess => status == PinRegistrationStatus.success;
  bool get isLoading => status == PinRegistrationStatus.loading;
  bool get isError => status == PinRegistrationStatus.error;
}

@freezed
class PinRegistrationState with _$PinRegistrationState {
  const factory PinRegistrationState({
    @Default(PinRegistrationStatus.initialState) status,
    String? errMsg,
  }) = _PinRegistrationState;
}
