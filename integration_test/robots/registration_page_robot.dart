import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/registration_page_finders.dart';
import '../../test_commons/utils/widget_tester.ext.dart';

class RegistrationPageRobot {
  const RegistrationPageRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [RegistrationPage] is shown
  Future<void> expectPageIsShown() async {
    expect(finderRegistrationPage, findsOneWidget);
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
