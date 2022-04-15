import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';
import 'package:storefront_app/features/order/widgets/order_details/status_header/widget.dart';

void main() {
  final dateFormat = DateFormat('d MMM y, HH:mm');
  final orderCreationTime = DateTime(2022, 1, 1, 12, 30, 5);

  group(
    'OrderStatusHeader',
    () {
      Future<void> pumpWidgetForTest(
        WidgetTester tester, {
        required String orderId,
        required DateTime orderCreationTime,
        required OrderStatus orderStatus,
        DateTime? estimatedArrivalTime,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OrderStatusHeader(
                orderId: orderId,
                orderCreationTime: orderCreationTime,
                orderStatus: orderStatus,
                estimatedArrivalTime: estimatedArrivalTime,
              ),
            ),
          ),
        );
      }

      testWidgets(
        'should display appropriate widgets for [OrderStatus.paid]',
        (tester) async {
          const orderId = 'order-id-1';
          const orderStatus = OrderStatus.paid;

          await pumpWidgetForTest(
            tester,
            orderId: orderId,
            orderCreationTime: orderCreationTime,
            estimatedArrivalTime: orderCreationTime.add(
              const Duration(minutes: 10),
            ),
            orderStatus: orderStatus,
          );

          expect(find.text(orderId), findsOneWidget);
          expect(
            find.text(dateFormat.format(orderCreationTime)),
            findsOneWidget,
          );
          expect(find.byType(DeliveryProgressBar), findsOneWidget);
          expect(find.byType(DeliveryTimeRemaining), findsOneWidget);
        },
      );

      testWidgets(
        'should display appropriate widgets for [OrderStatus.inDelivery]',
        (tester) async {
          const orderId = 'order-id-2';
          const orderStatus = OrderStatus.inDelivery;

          await pumpWidgetForTest(
            tester,
            orderId: orderId,
            orderCreationTime: orderCreationTime,
            estimatedArrivalTime: orderCreationTime.add(
              const Duration(minutes: 10),
            ),
            orderStatus: orderStatus,
          );

          expect(find.text(orderId), findsOneWidget);
          expect(
            find.text(dateFormat.format(orderCreationTime)),
            findsOneWidget,
          );
          expect(find.byType(DeliveryProgressBar), findsOneWidget);
          expect(find.byType(OrderStatusCaption), findsOneWidget);
          expect(find.byType(DeliveryTimeRemaining), findsOneWidget);
        },
      );

      testWidgets(
        'should display appropriate widgets for status [OrderStatus.arrived]',
        (tester) async {
          const orderId = 'order-id-3';
          const orderStatus = OrderStatus.arrived;

          await pumpWidgetForTest(
            tester,
            orderId: orderId,
            orderCreationTime: orderCreationTime,
            estimatedArrivalTime: orderCreationTime.add(
              const Duration(minutes: 10),
            ),
            orderStatus: orderStatus,
          );

          expect(find.text(orderId), findsOneWidget);
          expect(
            find.text(dateFormat.format(orderCreationTime)),
            findsOneWidget,
          );
          expect(find.byType(DeliveryProgressBar), findsOneWidget);
          expect(find.byType(OrderStatusCaption), findsOneWidget);
          expect(find.byType(DeliveryTimeRemaining), findsNothing);
        },
      );

      testWidgets(
        'should only display order ID and creation date for other statuses',
        (tester) async {
          const orderId = 'order-id-4';
          const orderStatuses = [
            OrderStatus.awaitingPayment,
            OrderStatus.unspecified,
            OrderStatus.cancelled,
          ];

          // Ensure same behavior for all other statuses
          for (final status in orderStatuses) {
            await pumpWidgetForTest(
              tester,
              orderId: orderId,
              orderCreationTime: orderCreationTime,
              orderStatus: status,
            );

            expect(find.text(orderId), findsOneWidget);
            expect(
              find.text(dateFormat.format(orderCreationTime)),
              findsOneWidget,
            );
            expect(find.byType(DeliveryProgressBar), findsNothing);
            expect(find.byType(OrderStatusCaption), findsNothing);
            expect(find.byType(DeliveryTimeRemaining), findsNothing);
          }
        },
      );
    },
  );
}
