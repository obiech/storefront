import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/utils/datetime.ext.dart';
import 'package:storefront_app/features/order/widgets/order_details/status_header/widget.dart';

import '../../../../../../../test_commons/utils/locale_setup.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<void> pumpWidgetForTest(int timeInSeconds) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeliveryTimeRemaining(timeInSeconds: timeInSeconds),
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
    'DeliveryTimeRemaining should tick down every second '
    'and stop ticking once time runs out',
    (tester) async {
      const time = 120;
      await tester.pumpWidgetForTest(time);

      for (int i = time; i >= 0; i--) {
        // expect text shown to be decreased by 1 second every time
        final dur = Duration(seconds: i);
        expect(find.text(dur.toMmSs()), findsOneWidget);

        // advance 1 second
        await tester.pump(const Duration(seconds: 1));
      }

      // should still display 00:00 after time runs out
      await tester.pump(const Duration(seconds: 60));

      expect(find.text('00:00'), findsOneWidget);
    },
  );
}
