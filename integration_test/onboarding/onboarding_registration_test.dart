import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:storefront_app/main.dart' as app;

import '../robots/address/request_location_access_page_robot.dart';
import '../robots/onboarding_screen_robot.dart';
import '../robots/otp_verification_screen_robot.dart';
import '../robots/pin_input_screen_robot.dart';
import '../robots/registration_screen_robot.dart';

const mockPhoneNumber = '+6281234567890'; // Test Number registered on Firebase
const mockPhoneNumberInput = '81234567890';
const mockOtp = '123456'; // Test Number registered on Firebase
const mockPin = '111111';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets(
    'Registration Flow -- on Onboarding Screen user can tap on Register button '
    'to access Registration Screen wherein they can submit their phone number. '
    'After clicking on Submit, they need to enter an OTP sent to their phone '
    'in OTP Verification Screen. Once OTP is verified and their account is '
    'registered to storefront-backend, they can register a new PIN in PIN '
    'registration screen. Then they will be asked to grant location access. ',
    (WidgetTester tester) async {
      // Setup robots
      final onboardingRobot = OnboardingScreenRobot(tester);
      final registrationRobot = RegistrationScreenRobot(tester);
      final otpVerificationRobot = OtpVerificationScreenRobot(tester);
      final pinInputRobot = PinInputScreenRobot(tester);
      final requestLocationAccessPageRobot =
          RequestLocationAccessPageRobot(tester);

      // Bootstrap the app
      await app.main();
      await tester.pumpAndSettle();

      await onboardingRobot.expectScreenIsShown();

      // Tap on Registration button and wait for animation
      await onboardingRobot.tapRegistrationButton();
      await tester.pumpAndSettle();

      // Used should be taken to Registration Screen
      await registrationRobot.expectScreenIsShown();

      // Enter phone number and submit
      await registrationRobot.enterPhoneNumber(mockPhoneNumberInput);
      await registrationRobot.tapOnSubmitButtonAndWaitForLoading();

      // User should be redirected to OTP verification Screen
      await otpVerificationRobot.expectScreenIsShown();

      // Wait for OTP to be sent and input that OTP
      await otpVerificationRobot.waitForOtpInputToBeEnabled();
      await otpVerificationRobot.enterOtp(mockOtp);

      // User should be redirected to PIN registration Screen
      await pinInputRobot.expectScreenIsShown();

      // Enter PIN and Confirm PIN and wait for PIN registration
      await pinInputRobot.enterPinAndConfirmPin(mockPin, mockPin);

      // User should be redirected to grant request Location Access page
      await requestLocationAccessPageRobot.expectScreenIsShown();

      // TODO (leovinsen): grant location access and proceed
    },
  );
}
