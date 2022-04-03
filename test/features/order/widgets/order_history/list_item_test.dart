import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/widgets/order_widgets.dart';

import '../../../../../test_commons/utils/sample_order_models.dart';

void main() {
  testWidgets(
    '[OrderHistoryListItem] should display a summary section, order thumbnail, '
    'and current order status',
    (tester) async {
      final order = sampleOrderModels[0];

      await tester.pumpWidget(
        MaterialApp(
          home: OrderHistoryListItem(order: order),
        ),
      );

      expect(find.byType(OrderSummarySection), findsOneWidget);
      expect(find.byType(OrderStatusChip), findsOneWidget);

      final orderThumbnail = tester.firstWidget(find.byType(CachedNetworkImage))
          as CachedNetworkImage;

      expect(
        orderThumbnail.imageUrl,
        order.productsBought[0].product.thumbnailUrl,
      );
    },
  );
}
