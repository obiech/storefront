import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

part 'account_availability_state.dart';

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
// TODO (leovinsen): Depend on Service instead of directly depending on gRPC client
  final CustomerServiceClient _customerServiceClient;

  AccountAvailabilityCubit(this._customerServiceClient)
      : super(const AccountAvailabilityInitial());

  /// On a successful request, emits:
  /// - [PhoneIsAvailable] if phone number is available.
  /// - [PhoneIsAlreadyRegistered] if phone number is already taken.
  ///
  /// On failure, emits a [AccountAvailabilityError].
  ///
  Future<void> checkPhoneNumberAvailability(String phoneNumber) async {
    emit(const AccountAvailabilityLoading());

    final req = CheckRequest(phoneNumber: phoneNumber);

    try {
      await _customerServiceClient.check(req);

      emit(const PhoneIsAlreadyRegistered());
    } on Exception catch (e) {
      final failure = e.toFailure;

      if (failure is ResourceNotFoundFailure) {
        emit(const PhoneIsAvailable());
      } else {
        emit(AccountAvailabilityError(failure.message));
      }
    }
  }
}
