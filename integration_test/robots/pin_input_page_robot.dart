import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/pin_input_page_finders.dart';
import '../../test_commons/utils/widget_tester.ext.dart';

class PinInputPageRobot {
  const PinInputPageRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [PinInputPage] is shown
  Future<void> expectPageIsShown() async {
    await tester.pumpAndSettle();
    expect(finderPinInputPage, findsOneWidget);
  }

  /// Enters a PIN followed by Confirm PIN
  Future<void> enterPinAndConfirmPin(String pin, String confirmPin) async {
    await tester.enterTextLetterByLetter(
      finderInputPin,
      pin,
    );

    // Wait for transtition animation to complete
    await tester.pumpAndSettle();

    await tester.enterTextLetterByLetter(
      finderInputConfirmPin,
      confirmPin,
    );

    // Wait for PIN registration process to resolve
    await tester.pumpAndSettle();
  }
}
