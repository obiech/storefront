import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import '../../../home/screens/home_page.dart';
import '../../blocs/blocs.dart';
import '../pin_input/pin_input_screen.dart';
import 'otp_input_field.dart';
import 'otp_success_action.dart';
import 'resend_otp_timer.dart';

/// Screen for performing OTP verification for given [phoneNumberIntlFormat].
/// Supports resending OTP with a delay before user is able to request a new OTP
/// defined in [ResendOtpTimer].
///
/// On successful verification, currently has 2 behavior defined with
/// [OtpSuccessBehavior]:
///
/// - [OtpSuccessBehavior.goToHome]: Pops all current routes and push
/// [HomePage.routeName] as replacement.
/// - [OtpSuccessBehavior.goToPinPage]: Pushes [PinInputScreen.routeName].
class OtpVerificationScreen extends StatefulWidget {
  static const routeName = '/otp-input';

  const OtpVerificationScreen({
    Key? key,
    required this.phoneNumberIntlFormat,
    required this.successAction,
    required this.timeoutInSeconds,
    this.registerAccountAfterSuccessfulOtp = false,
  }) : super(key: key);

  final String phoneNumberIntlFormat;
  final int timeoutInSeconds;
  final OtpSuccessAction successAction;
  final bool registerAccountAfterSuccessfulOtp;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String get phoneNumberLocalFormat =>
      widget.phoneNumberIntlFormat.replaceAll('+62', '0');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountVerificationCubit, AccountVerificationState>(
      listener: (context, state) {
        final status = state.status as AccountVerificationStatus;

        switch (status) {
          case AccountVerificationStatus.success:
            _onSuccessfulVerification();
            break;
          case AccountVerificationStatus.error:
            showErrorBottomSheet(context, state.errMsg!);
            break;
          default:
            break;
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
    switch (widget.successAction) {
      case OtpSuccessAction.goToHomeScreen:
        getIt<IPrefsRepository>().setIsOnBoarded(true);
        // Removes all previous routes and push HomeScreen as new route
        context.router.replaceAll([const MainRoute()]);
        break;
      case OtpSuccessAction.goToPinScreen:
        context.router.push(const PinInputRoute());
        break;
    }
  }
}
