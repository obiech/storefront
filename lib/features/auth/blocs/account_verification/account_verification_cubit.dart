import 'dart:async';

import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../../auth/index.dart';
import '../../domain/repository/phone_verification_result.dart';
import '../../domain/services/auth_service.dart';

part 'account_verification_state.dart';

/// Resposible for verifying performing account verification
/// using Firebase Auth Phone Signin.
///
/// when [isRegistration] is true, this will
/// call [CustomerServiceClient.register] before OTP verification
/// to register the account with storefront-backend.
///
/// It is crucial that [CustomerServiceClient.register] is called BEFORE
/// OTP verification to prevent Firebase from creating the user account
/// before storefront-backend has managed to do so.
class AccountVerificationCubit extends Cubit<AccountVerificationState> {
  /// Immediately listen to [_authService.phoneVerificationStream]
  AccountVerificationCubit(
    this._authService,
    this._customerRepository,
    this.isRegistration,
  ) : super(const AccountVerificationInitial()) {
    _phoneVerificationSubscription = _authService.phoneVerificationStream
        .listen(_handlePhoneVerificationResult);
  }

  late StreamSubscription _phoneVerificationSubscription;

  final AuthService _authService;
  final ICustomerRepository _customerRepository;
  final bool isRegistration;

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
        emit(const AccountVerificationSuccess());
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

    // In registration flow, register phone number with backend before
    // attempting OTP verification.
    // If a failure occured, terminate the whole process.
    if (isRegistration) {
      final result = await _customerRepository.registerPhoneNumber(phoneNumber);

      if (result.isLeft()) {
        final failure = result.getLeft();
        emit(AccountVerificationError(failure.message));
        return;
      }
    }

    await _authService.sendOtp(phoneNumber);
  }

  /// Verifies sumitted OTP against actual OTP
  /// will emit an error state if otp is not yet sent
  Future<void> verifyOtp(String otp) async {
    // TODO (leovinsen): Remove if this check is not necessary
    // Disabling the requirement that OTP has to be sent before user
    // are allowed to enter OTP.
    // Reason is using Test Phone Number does not send an OTP,
    // and this check blocks verification of these numbers.

    // if (!otpIsSent) {
    //   // TODO (leovinsen): Handle error message in UI side
    //   emit(const AccountVerificationError('OTP belum terkirim!'));
    //   return;
    // }

    emit(const AccountVerificationLoading());

    await _authService.verifyOtp(otp);
  }

  @override
  Future<void> close() {
    _phoneVerificationSubscription.cancel();
    return super.close();
  }
}
