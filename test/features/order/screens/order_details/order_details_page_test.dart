import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/fixtures/order/order_models.dart';

void main() {
  group(
    'OrderDetailsPage',
    () {
      testWidgets(
        'should show list of purchased products and transaction summary',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: OrderDetailsPage(
                order: orderAwaitingPayment,
              ),
            ),
          );

          expect(find.byType(OrderDetailsSection), findsOneWidget);
          expect(find.byType(OrderPaymentSummary), findsOneWidget);
        },
      );
    },
  );
}
