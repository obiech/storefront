import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../test_commons/finders/otp_verification_page_finders.dart';
import '../../test_commons/utils/widget_tester.ext.dart';

class OtpVerificationPageRobot {
  const OtpVerificationPageRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [OtpVerificationPage] is shown
  Future<void> expectPageIsShown() async {
    expect(finderOtpVerificationPage, findsOneWidget);
  }

  Future<void> enterOtp(String otp) async {
    await tester.enterText(finderInputOtp, otp);

    // It will be enabled after API calls are resolved
    await waitForOtpInputToBeEnabled();
  }

  /// Wait until OTP input is enabled i.e. Firebase has sent an OTP to
  /// specified phone number
  Future<void> waitForOtpInputToBeEnabled() async {
    await tester.waitFor(
      evaluateCondition: () {
        return tester.widget<PinCodeTextField>(finderInputOtpTextField).enabled;
      },
      timeout: const Duration(seconds: 60),
    );
  }
}
