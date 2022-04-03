import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/widgets/order_history/list.dart';

import '../../../../../test_commons/utils/sample_order_models.dart';

void main() {
  testWidgets(
    '[OrderHistoryList] should create a [OrderHistoryListItem] for every '
    '[OrderModel]',
    (tester) async {
      final orders = sampleOrderModels;

      await tester.pumpWidget(
        MaterialApp(
          home: OrderHistoryList(orders: orders),
        ),
      );

      for (int i = 0; i < orders.length; i++) {
        // Ensure OrderHistoryListItem is created for every model
        expect(
          find.byKey(
            ValueKey(OrderHistoryListKeys.listItem(i)),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
      }
    },
  );
}
