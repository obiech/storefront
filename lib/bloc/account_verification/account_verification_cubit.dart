import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';

import '../../domain/auth/phone_verification_result.dart';
import '../../network/grpc/customer/customer.pbgrpc.dart';
import '../../services/auth/auth_service.dart';
import 'account_verification_state.dart';

/// [Cubit] resposible for orchestrating account verification.
///
/// [_authService] handles the verification process, whereas
/// [_customerServiceClient] will be used to register the phone number
/// to backend.
class AccountVerificationCubit extends Cubit<AccountVerificationState> {
  /// Immediately listen to [_authService.phoneVerificationStream]
  AccountVerificationCubit(
    this._authService,
    this._customerServiceClient,
    this.registerAccountAfterSuccessfulOtp,
  ) : super(const AccountVerificationState()) {
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

  void _handlePhoneVerificationResult(PhoneVerificationResult result) async {
    switch (result.status) {
      case PhoneVerificationStatus.otpSent:
        emit(const AccountVerificationState(
          status: AccountVerificationStatus.otpSent,
        ));
        otpIsSent = true;
        break;

      case PhoneVerificationStatus.verifiedSuccessfully:
        emit(const AccountVerificationState(
          status: AccountVerificationStatus.registeringAccount,
        ));

        if (registerAccountAfterSuccessfulOtp) {
          await _registerPhoneNumberToBackend();
        } else {
          emit(const AccountVerificationState(
            status: AccountVerificationStatus.success,
          ));
        }
        break;

      case PhoneVerificationStatus.error:
        final exception = result.exception!;

        emit(AccountVerificationState(
          status: AccountVerificationStatus.error,
          errMsg: exception.errorMessage,
        ));

        break;
      case PhoneVerificationStatus.invalidOtp:
        final exception = result.exception!;
        emit(AccountVerificationState(
          status: AccountVerificationStatus.invalidOtp,
          errMsg: exception.errorMessage,
        ));
        break;
    }
  }

  /// Registers [phoneNumber] to storefront backend.
  /// Call only after a successful OTP verification to ensure its validity.
  Future<void> _registerPhoneNumberToBackend() async {
    final request = RegisterRequest(phoneNumber: phoneNumber);

    try {
      await _customerServiceClient.register(request);
      emit(const AccountVerificationState(
        status: AccountVerificationStatus.success,
      ));
    } on GrpcError catch (e) {
      emit(AccountVerificationState(
        status: AccountVerificationStatus.error,
        errMsg: e.message,
      ));
    } catch (e) {
      emit(AccountVerificationState(
        status: AccountVerificationStatus.error,
        errMsg: e.toString(),
      ));
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
    emit(const AccountVerificationState(
        status: AccountVerificationStatus.sendingOtp));

    await _authService.sendOtp(phoneNumber);
  }

  /// Verifies sumitted OTP against actual OTP
  /// will emit an error state if otp is not yet sent
  Future<void> verifyOtp(String otp) async {
    if (!otpIsSent) {
      emit(const AccountVerificationState(
        status: AccountVerificationStatus.error,
        errMsg: 'OTP belum terkirim!',
      ));

      return;
    }

    emit(const AccountVerificationState(
        status: AccountVerificationStatus.verifyingOtp));

    await _authService.verifyOtp(otp);
  }

  @override
  Future<void> close() {
    _phoneVerificationSubscription.cancel();
    return super.close();
  }
}
