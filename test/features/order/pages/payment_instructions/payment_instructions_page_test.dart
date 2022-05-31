import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/fixtures/order/order_models.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<void> pumpPaymentInstructionsPage({
    required OrderModel order,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaymentInstructionsPage(order: order),
        ),
      ),
    );
  }
}

void main() {
  testWidgets(
      'Should show [PaymentInformationSection] and [ContactSupportButton] '
      'when [PaymentInstructionsPage] is shown', (tester) async {
    await tester.pumpPaymentInstructionsPage(order: orderAwaitingPayment);

    expect(find.byType(PaymentInformationSection), findsOneWidget);
    // TODO : add expect for payment help section here
    expect(find.byType(ContactSupportButton), findsOneWidget);
  });
}
