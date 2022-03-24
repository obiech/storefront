import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/grpc/customer/customer.pbgrpc.dart';
import '../../../../core/services/prefs/i_prefs_repository.dart';
import 'account_availability_state.dart';

/// [Cubit] for checking whether an account credentials is already registered
/// in Dropezy backend.
///
/// Currently it handles only phone number checking, but may be expanded
/// in the future to include Social Media login or Single Sign On.
///
/// This [Cubit] can be used and is intended for both Registration
/// and Login flow.
@injectable
class AccountAvailabilityCubit extends Cubit<AccountAvailabilityState> {
  final CustomerServiceClient _customerServiceClient;
  final IPrefsRepository prefs;

  AccountAvailabilityCubit(this._customerServiceClient, this.prefs)
      : super(const AccountAvailabilityState());

  /// On a successful request, will emit a [AccountAvailabilityState] with status of
  /// [AccountAvailabilityStatus.phoneIsAvailable] if phone number is available
  /// or [AccountAvailabilityStatus.phoneAlreadyRegistered] if phone number is already taken
  ///
  /// On failure, will return [AccountAvailabilityState] with status of
  /// [AccountAvailabilityStatus.error]
  /// Retrieve the error message from [AccountAvailabilityState.errMsg]
  ///
  void checkPhoneNumberAvailability(String phoneNumber) async {
    // Notify UI that verification process has started
    emit(
      const AccountAvailabilityState(
        status: AccountAvailabilityStatus.loading,
      ),
    );

    final req = CheckRequest(phoneNumber: phoneNumber);

    try {
      await _customerServiceClient.check(req);

      emit(
        const AccountAvailabilityState(
          status: AccountAvailabilityStatus.phoneAlreadyRegistered,
        ),
      );
    } catch (e) {
      String? msg;
      int? statusCode;

      if (e is GrpcError) {
        msg = e.message;
        statusCode = e.code;
      } else {
        //TODO: Define a standard status code for errors other than GrpcError
        msg = e.toString();
      }

      if (statusCode == StatusCode.notFound) {
        emit(
          AccountAvailabilityState(
            status: AccountAvailabilityStatus.phoneIsAvailable,
            errStatusCode: statusCode,
          ),
        );
      } else {
        emit(
          AccountAvailabilityState(
            status: AccountAvailabilityStatus.error,
            errMsg: msg,
            errStatusCode: statusCode,
          ),
        );
      }
    }

    // Store user phone number to prefs
    await prefs.setUserPhoneNumber(phoneNumber);
  }
}
