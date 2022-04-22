import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';
import 'package:storefront_app/features/order/widgets/order_widgets.dart';

import '../../../../../../test_commons/utils/sample_order_models.dart';

void main() {
  testWidgets(
    '[OrderHistoryListItem] should display a summary section, order thumbnail, '
    'and current order status regardless of order status',
    (tester) async {
      Future<void> testBasicScenarios(
        WidgetTester tester,
        OrderModel order,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: OrderHistoryListItem(order: order),
          ),
        );

        expect(find.byType(OrderSummarySection), findsOneWidget);
        expect(find.byType(OrderStatusChip), findsOneWidget);

        final orderThumbnail = tester
            .firstWidget(find.byType(CachedNetworkImage)) as CachedNetworkImage;

        expect(
          orderThumbnail.imageUrl,
          order.productsBought[0].product.thumbnailUrl,
        );
      }

      for (final o in sampleOrderModels) {
        await testBasicScenarios(tester, o);
      }
    },
  );

  testWidgets(
    '[OrderHistoryListItem] should also display a [OrderStatusTimings] and '
    'a [DropezyButton] if status is awaiting for payment',
    (tester) async {
      final order = sampleOrderModels
          .firstWhere((el) => el.status == OrderStatus.awaitingPayment);

      await tester.pumpWidget(
        MaterialApp(
          home: OrderHistoryListItem(order: order),
        ),
      );

      expect(find.byType(OrderSummarySection), findsOneWidget);
      expect(find.byType(OrderStatusChip), findsOneWidget);
      expect(find.byType(OrderStatusTimings), findsOneWidget);
      expect(find.byType(DropezyButton), findsOneWidget);

      final orderThumbnail = tester.firstWidget(find.byType(CachedNetworkImage))
          as CachedNetworkImage;

      expect(
        orderThumbnail.imageUrl,
        order.productsBought[0].product.thumbnailUrl,
      );
    },
  );

  testWidgets(
    '[OrderHistoryListItem] should also display a [OrderStatusTimings] and '
    'if status is paid and being processed',
    (tester) async {
      final order =
          sampleOrderModels.firstWhere((el) => el.status == OrderStatus.paid);

      await tester.pumpWidget(
        MaterialApp(
          home: OrderHistoryListItem(order: order),
        ),
      );

      expect(find.byType(OrderSummarySection), findsOneWidget);
      expect(find.byType(OrderStatusChip), findsOneWidget);
      expect(find.byType(OrderStatusTimings), findsOneWidget);
      expect(find.byType(DropezyButton), findsNothing);

      final orderThumbnail = tester.firstWidget(find.byType(CachedNetworkImage))
          as CachedNetworkImage;

      expect(
        orderThumbnail.imageUrl,
        order.productsBought[0].product.thumbnailUrl,
      );
    },
  );

  testWidgets(
    '[OrderHistoryListItem] should also display a [OrderStatusTimings] and '
    'if status is in delivery',
    (tester) async {
      final order = sampleOrderModels
          .firstWhere((el) => el.status == OrderStatus.inDelivery);

      await tester.pumpWidget(
        MaterialApp(
          home: OrderHistoryListItem(order: order),
        ),
      );

      expect(find.byType(OrderSummarySection), findsOneWidget);
      expect(find.byType(OrderStatusChip), findsOneWidget);
      expect(find.byType(OrderStatusTimings), findsOneWidget);
      expect(find.byType(DropezyButton), findsNothing);

      final orderThumbnail = tester.firstWidget(find.byType(CachedNetworkImage))
          as CachedNetworkImage;

      expect(
        orderThumbnail.imageUrl,
        order.productsBought[0].product.thumbnailUrl,
      );
    },
  );

  testWidgets(
    '[OrderHistoryListItem] should also display a [OrderStatusTimings] and '
    'a [DropezyButton] if status is already delivered',
    (tester) async {
      final order = sampleOrderModels
          .firstWhere((el) => el.status == OrderStatus.awaitingPayment);

      await tester.pumpWidget(
        MaterialApp(
          home: OrderHistoryListItem(order: order),
        ),
      );

      expect(find.byType(OrderSummarySection), findsOneWidget);
      expect(find.byType(OrderStatusChip), findsOneWidget);
      expect(find.byType(OrderStatusTimings), findsOneWidget);
      expect(find.byType(DropezyButton), findsOneWidget);

      final orderThumbnail = tester.firstWidget(find.byType(CachedNetworkImage))
          as CachedNetworkImage;

      expect(
        orderThumbnail.imageUrl,
        order.productsBought[0].product.thumbnailUrl,
      );
    },
  );
}
