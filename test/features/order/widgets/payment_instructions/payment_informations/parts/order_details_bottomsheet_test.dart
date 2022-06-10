import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../../../test_commons/fixtures/order/order_models.dart';
import '../../../../../../../test_commons/utils/locale_setup.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
      'Should show [OrderPaymentSummary], [OrderDetailsSection], and [DeliveryAddressDetail] '
      'when [OrderDetailsBottomSheet] is shown', (tester) async {
    await tester.pumpBottomSheet();

    expect(find.byType(OrderPaymentSummary), findsOneWidget);
    expect(find.byType(OrderDetailsSection), findsOneWidget);
    expect(find.byType(DeliveryAddressDetail), findsOneWidget);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpBottomSheet() async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: OrderDetailsBottomSheet(order: orderAwaitingPayment),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
