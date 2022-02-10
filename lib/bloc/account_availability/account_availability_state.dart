import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_availability_state.freezed.dart';

enum AccountAvailabilityStatus {
  initialState,
  loading,
  phoneIsAvailable,
  phoneAlreadyRegistered,
  error,
}

@freezed
class AccountAvailabilityState with _$AccountAvailabilityState {
  const factory AccountAvailabilityState({
    @Default(AccountAvailabilityStatus.initialState) status,
    String? errMsg,
    int? errStatusCode,
  }) = _AccountAvailabilityState;
}
