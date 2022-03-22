import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/dropezy_colors.dart';
import '../../constants/dropezy_text_styles.dart';

/// A [Widget] that shows a countdown if [resendWaitPeriodInSeconds]
/// seconds has not elapsed, otherwise shows a clickable text that
/// calls [onResendTap] when clicked.
///
/// This [Widget] adds a padding (TRB) to enlarge its tap size as defined in
/// [paddingForTapArea], so make sure to subtract this amount from
/// margin when placing [ResendOtpTimer] on a page.
class ResendOtpTimer extends StatefulWidget {
  static const paddingForTapArea = 4.0;

  static const keyTextCountdown = 'resendOtpTimer_textCountdown';
  static const keyTextResend = 'resendOtpTimer_textResend';

  const ResendOtpTimer({
    Key? key,
    required this.onResendTap,
    required this.resendWaitPeriodInSeconds,
  }) : super(key: key);

  final int resendWaitPeriodInSeconds;
  final VoidCallback onResendTap;

  @override
  ResendOtpTimerState createState() => ResendOtpTimerState();
}

class ResendOtpTimerState extends State<ResendOtpTimer> {
  @visibleForTesting
  late Timer otpTimer;

  @visibleForTesting
  late int secsBeforeEnablingResend;

  @override
  void initState() {
    super.initState();
    startResendOtpTimer();
  }

  @override
  void dispose() {
    otpTimer.cancel();
    super.dispose();
  }

  /// Timer for counting down time before resending OTP
  @visibleForTesting
  void startResendOtpTimer() {
    secsBeforeEnablingResend = widget.resendWaitPeriodInSeconds;

    otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secsBeforeEnablingResend == 0) {
        otpTimer.cancel();
      } else {
        secsBeforeEnablingResend--;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canResend = secsBeforeEnablingResend > 0;
    return canResend ? _countdownText() : _resendOtpText();
  }

  Widget _resendOtpText() {
    return InkWell(
      onTap: () {
        widget.onResendTap();
        startResendOtpTimer();

        // Force rebuild
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: ResendOtpTimer.paddingForTapArea,
          bottom: ResendOtpTimer.paddingForTapArea,
          right: ResendOtpTimer.paddingForTapArea,
        ),
        child: Text(
          'Kirim Ulang OTP',
          key: const Key(ResendOtpTimer.keyTextResend),
          style: DropezyTextStyles.caption2.copyWith(
            color: DropezyColors.blue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _countdownText() {
    final String secs = secsBeforeEnablingResend.toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.only(
        top: ResendOtpTimer.paddingForTapArea,
        bottom: ResendOtpTimer.paddingForTapArea,
        right: ResendOtpTimer.paddingForTapArea,
      ),
      child: Text.rich(
        TextSpan(
          text: 'Kirim ulang ',
          children: [
            TextSpan(
              text: '(00:$secs)',
              style: DropezyTextStyles.caption2.copyWith(
                color: DropezyColors.blue,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        key: const Key(ResendOtpTimer.keyTextCountdown),
        style: DropezyTextStyles.caption2,
      ),
    );
  }
}
