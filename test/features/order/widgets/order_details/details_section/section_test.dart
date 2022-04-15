import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/utils/build_context.ext.dart';
import 'package:storefront_app/features/order/widgets/order_details/details_section/section.dart';

import '../../../../../../test_commons/fixtures/order/order_models.dart';

void main() {
  testWidgets(
    "[OrderDetails] consists of a heading text 'order details' and a list of "
    'purchased products',
    (tester) async {
      // setup
      late BuildContext ctx;

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ctx = context;
              return Scaffold(
                body: OrderDetailsSection(
                  products: orderAwaitingPayment.productsBought,
                ),
              );
            },
          ),
        ),
      );

      // assert
      // H1 heading 'Order Details'
      expect(find.text(ctx.res.strings.orderDetails), findsOneWidget);
      // H2 heading 'Your purchases'
      expect(find.text(ctx.res.strings.yourPurchases), findsOneWidget);
      // List of purchased products
      expect(find.byType(ProductsList), findsOneWidget);
    },
  );
}
