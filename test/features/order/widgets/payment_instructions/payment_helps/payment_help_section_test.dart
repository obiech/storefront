import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../../test_commons/finders/payment_instructions/payment_helps_section_finder.dart';
import '../../../../../commons.dart';

void main() {
  setUp(() {
    setUpLocaleInjection();
  });

  group('[PaymentHelpSection]', () {
    testWidgets(
      'Should show [How To Pay text], [ATM Tile], [Klik BCA Tile], [m-BCA Tile]',
      (tester) async {
        await tester.pumpPaymentHelpSection();

        expect(PaymentHelpsSectionFinder.finderHowToPayText, findsOneWidget);
        expect(PaymentHelpsSectionFinder.finderATM, findsOneWidget);
        expect(PaymentHelpsSectionFinder.finderKlikBCA, findsOneWidget);
        expect(PaymentHelpsSectionFinder.finderMBCA, findsOneWidget);
      },
    );
  });
}

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<void> pumpPaymentHelpSection() async {
    await pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PaymentHelpSection(),
        ),
      ),
    );
  }
}
