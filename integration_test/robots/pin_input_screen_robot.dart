import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/pin_input_screen_finders.dart';
import '../../test_commons/utils/widget_tester.ext.dart';

class PinInputScreenRobot {
  const PinInputScreenRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [PinInputScreen] is shown
  Future<void> expectScreenIsShown() async {
    await tester.pumpAndSettle();
    expect(finderPinInputScreen, findsOneWidget);
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
