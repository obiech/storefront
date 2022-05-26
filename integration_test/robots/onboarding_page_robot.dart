import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/onboarding_page_finders.dart';

class OnboardingPageRobot {
  const OnboardingPageRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [OnboardingPage] is shown
  Future<void> expectPageIsShown() async {
    expect(finderOnboardingPage, findsOneWidget);
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
