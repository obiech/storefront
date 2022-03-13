import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/registration_screen_finders.dart';
import '../../test_commons/utils/widget_tester.ext.dart';

class RegistrationScreenRobot {
  const RegistrationScreenRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [RegistrationScreen] is shown
  Future<void> expectScreenIsShown() async {
    expect(finderRegistrationScreen, findsOneWidget);
  }

  Future<void> enterPhoneNumber(String phoneNumber) async {
    await tester.enterTextLetterByLetter(
      finderInputPhoneNumber,
      phoneNumber,
    );
  }

  Future<void> tapOnSubmitButtonAndWaitForLoading() async {
    await tester.tap(finderButtonVerifyPhone);

    // Trigger loading indicator
    await tester.pump();

    await tester.waitFor(
      evaluateCondition: () {
        try {
          expect(finderLoadingIndicator, findsNothing);
          return true;
        } on TestFailure {
          return false;
        }
      },
    );
  }
}
