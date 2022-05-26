import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/login_page_finders.dart';
import '../../test_commons/utils/widget_tester.ext.dart';

class LoginPageRobot {
  const LoginPageRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [LoginPage] is shown
  Future<void> expectPageIsShown() async {
    expect(finderLoginPage, findsOneWidget);
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
