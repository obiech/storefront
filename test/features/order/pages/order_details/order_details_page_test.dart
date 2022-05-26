import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/fixtures/order/order_models.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<void> pumpOrderDetailsPage({required OrderModel order}) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderDetailsPage(order: order),
        ),
      ),
    );
  }
}

void main() {
  group(
    'OrderDetailsPage',
    () {
      final finderStatusHeader = find.byType(
        OrderStatusHeader,
        skipOffstage: false,
      );
      final finderDetailsSection = find.byType(
        OrderDetailsSection,
        skipOffstage: false,
      );
      final finderPaymentSummary = find.byType(
        OrderPaymentSummary,
        skipOffstage: false,
      );
      final finderDriverAndRecipientSection = find.byType(
        DriverAndRecipientSection,
        skipOffstage: false,
      );
      final finderContactSupportButton = find.byType(
        ContactSupportButton,
        skipOffstage: false,
      );

      testWidgets(
        'for [OrderStatus.awaitingPayment] should show order status header, '
        'list of purchased products, transaction summary, '
        'and a button to contact support',
        (tester) async {
          await tester.pumpOrderDetailsPage(order: orderAwaitingPayment);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsNothing);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );

      testWidgets(
        'for [OrderStatus.paid] should show order status header, '
        'list of purchased products, transaction summary, '
        'and a button to contact support',
        (tester) async {
          await tester.pumpOrderDetailsPage(order: orderPaid);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsNothing);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );

      testWidgets(
        'for [OrderStatus.inDelivery] should show order status header, '
        'list of purchased products, transaction summary, driver information '
        'and a button to contact support',
        (tester) async {
          await tester.pumpOrderDetailsPage(order: orderInDelivery);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsOneWidget);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );

      testWidgets(
        'for [OrderStatus.arrived] should show order status header, '
        'list of purchased products, transaction summary, driver and '
        'recipient information, and a button to contact support',
        (tester) async {
          await tester.pumpOrderDetailsPage(order: orderArrived);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsOneWidget);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );
    },
  );
}
