import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/onboarding_screen_finders.dart';

class OnboardingScreenRobot {
  const OnboardingScreenRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [OnboardingScreen] is shown
  Future<void> expectScreenIsShown() async {
    expect(finderOnboardingScreen, findsOneWidget);
  }

  /// Taps on Registration Button
  Future<void> tapRegistrationButton() async {
    await tester.tap(finderButtonRegister);
  }

  /// Taps on Login Button
  Future<void> tapLoginButton() async {
    await tester.tap(finderButtonLogin);
  }
}
