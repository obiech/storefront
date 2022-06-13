import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import '../../../home/pages/home_page.dart';
import '../../blocs/account_verification/account_verification_cubit.dart';
import '../../domain/domain.dart';
import '../../domain/services/auth_service.dart';
import '../pin_input/pin_input_page.dart';

part 'otp_input_field.dart';
part 'otp_success_action.dart';
part 'resend_otp_timer.dart';
part 'wrapper.dart';

/// Page for performing OTP verification for given [phoneNumberIntlFormat].
/// Supports resending OTP with a delay before user is able to request a new OTP
/// defined in [ResendOtpTimer].
///
/// On successful verification, currently has 2 behavior defined with
/// [OtpSuccessBehavior]:
///
/// - [OtpSuccessBehavior.goToHome]: Pops all current routes and push
/// [HomePage.routeName] as replacement.
/// - [OtpSuccessBehavior.goToPinPage]: Pushes [PinInputPage.routeName].
class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({
    Key? key,
    required this.phoneNumberIntlFormat,
    required this.successAction,
    required this.timeoutInSeconds,
    this.isRegistration = false,
  }) : super(key: key);

  final String phoneNumberIntlFormat;
  final int timeoutInSeconds;
  final OtpSuccessAction successAction;
  final bool isRegistration;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String get phoneNumberLocalFormat =>
      widget.phoneNumberIntlFormat.replaceAll('+62', '0');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountVerificationCubit, AccountVerificationState>(
      listener: (context, state) {
        if (state is AccountVerificationSuccess) {
          _onSuccessfulVerification();
        } else if (state is AccountVerificationError) {
          showErrorBottomSheet(context, state.errorMsg);
        }
      },
      child: DropezyScaffold.textTitle(
        title: 'Kode OTP',
        child: Padding(
          padding: EdgeInsets.only(
            left: context.res.dimens.spacingMlarge,
            right: context.res.dimens.spacingMlarge,
            top: context.res.dimens.spacingMlarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verifikasi Ponsel Kamu',
                style: DropezyTextStyles.title,
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  text: 'Kode OTP telah dikirimkan ke nomor ',
                  children: [
                    TextSpan(
                      text: phoneNumberLocalFormat,
                      style: DropezyTextStyles.caption2
                          .copyWith(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                style: DropezyTextStyles.caption1,
              ),
              const SizedBox(height: 24),
              const OtpInputField(),
              const SizedBox(height: 24 - ResendOtpTimer.paddingForTapArea),
              ResendOtpTimer(
                resendWaitPeriodInSeconds: widget.timeoutInSeconds,
                onResendTap: () {
                  context
                      .read<AccountVerificationCubit>()
                      .sendOtp(widget.phoneNumberIntlFormat);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSuccessfulVerification() {
    getIt<IPrefsRepository>().setIsOnBoarded(true);
    switch (widget.successAction) {
      case OtpSuccessAction.goToHomePage:
        // Removes all previous routes and push HomePage as new route
        context.router.replaceAll([const MainRoute()]);
        break;
      case OtpSuccessAction.goToRequestLocationAccessPage:
        context.router.replaceAll([
          const MainRoute(),
          const RequestLocationAccessRoute(),
        ]);
        break;
    }
  }
}
