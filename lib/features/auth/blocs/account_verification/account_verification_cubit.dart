import 'dart:async';

import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../domain/repository/phone_verification_result.dart';
import '../../domain/services/auth_service.dart';

part 'account_verification_state.dart';

/// [Cubit] resposible for orchestrating account verification.
///
/// [_authService] handles the verification process, whereas
/// [_customerServiceClient] will be used to register the phone number
/// to backend.
class AccountVerificationCubit extends Cubit<AccountVerificationState> {
  /// Immediately listen to [_authService.phoneVerificationStream]
// TODO (leovinsen): Depend on Service instead of directly depending on gRPC client
  AccountVerificationCubit(
    this._authService,
    this._customerServiceClient,
    this.registerAccountAfterSuccessfulOtp,
  ) : super(const AccountVerificationInitial()) {
    _phoneVerificationSubscription = _authService.phoneVerificationStream
        .listen(_handlePhoneVerificationResult);
  }

  late StreamSubscription _phoneVerificationSubscription;

  final AuthService _authService;
  final CustomerServiceClient _customerServiceClient;
  final bool registerAccountAfterSuccessfulOtp;

  /// will be used for registration in backend after phone verification
  late String phoneNumber;

  bool otpIsSent = false;

  Future<void> _handlePhoneVerificationResult(
    PhoneVerificationResult result,
  ) async {
    switch (result.status) {
      case PhoneVerificationStatus.otpSent:
        emit(const AccountVerificationOtpIsSent());
        otpIsSent = true;
        break;

      case PhoneVerificationStatus.verifiedSuccessfully:
        emit(const AccountVerificationLoading());

        if (registerAccountAfterSuccessfulOtp) {
          await _registerPhoneNumberToBackend();
        } else {
          emit(const AccountVerificationSuccess());
        }
        break;

      case PhoneVerificationStatus.error:
        final exception = result.exception!;

        emit(AccountVerificationError(exception.errorMessage));

        break;
      case PhoneVerificationStatus.invalidOtp:
        emit(const AccountVerificationInvalidOtp());
        break;
    }
  }

  /// Registers [phoneNumber] to storefront backend.
  /// Call only after a successful OTP verification to ensure its validity.
  Future<void> _registerPhoneNumberToBackend() async {
    final request = RegisterRequest(phoneNumber: phoneNumber);

    try {
      await _customerServiceClient.register(request);
      emit(const AccountVerificationSuccess());
    } on Exception catch (e) {
      emit(AccountVerificationError(e.toFailure.message));
    }
  }

  /// [phoneNumber] in intl format (i.e. +6281234567890).
  ///
  /// Will emit State with status of [AccountVerificationStatus.sendingOtp].
  ///
  /// Will emit State with status of [AccountVerificationStatus.otpSent]
  /// after [_authService] successfully sends an OTP.
  ///
  /// If an error occurs during the process, will emit a State with status of
  /// [AccountVerificationStatus.error].
  Future<void> sendOtp(String phoneNumber) async {
    this.phoneNumber = phoneNumber;
    emit(const AccountVerificationLoading());

    await _authService.sendOtp(phoneNumber);
  }

  /// Verifies sumitted OTP against actual OTP
  /// will emit an error state if otp is not yet sent
  Future<void> verifyOtp(String otp) async {
    if (!otpIsSent) {
      // TODO (leovinsen): Handle error message in UI side
      emit(const AccountVerificationError('OTP belum terkirim!'));
      return;
    }

    emit(const AccountVerificationLoading());

    await _authService.verifyOtp(otp);
  }

  @override
  Future<void> close() {
    _phoneVerificationSubscription.cancel();
    return super.close();
  }
}
