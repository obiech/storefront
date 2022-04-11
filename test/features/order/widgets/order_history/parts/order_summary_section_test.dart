import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/utils/build_context.ext.dart';
import 'package:storefront_app/core/utils/string.ext.dart';
import 'package:storefront_app/features/order/utils/order_products_summarizer.dart';
import 'package:storefront_app/features/order/widgets/order_history/list.dart';

import '../../../../../../test_commons/utils/sample_order_models.dart';

void main() {
  testWidgets(
    'OrderSummarySection should display a summary of bought products '
    'and the amount spent by customer',
    (tester) async {
      final sampleOrder = sampleOrderModels[0];
      late String otherProductsLabel;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              otherProductsLabel = context.res.strings.otherProducts;
              return OrderSummarySection(
                order: sampleOrder,
              );
            },
          ),
        ),
      );

      final productSummary = summarizeOrderProducts(
        sampleOrder.productsBought,
        otherProductsLabel,
      );

      // expect to find product summary
      expect(find.text(productSummary), findsOneWidget);

      // expect to find amount spent by user
      expect(find.text(sampleOrder.total.toCurrency()), findsOneWidget);
    },
  );
}
