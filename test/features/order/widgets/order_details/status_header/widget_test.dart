import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:storefront_app/core/utils/_exporter.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';
import 'package:storefront_app/features/order/widgets/order_details/status_header/widget.dart';

import '../../../../../../test_commons/utils/locale_setup.dart';

void main() {
  final dateFormat = DateFormat('d MMM y, HH:mm');
  final orderCreationTime = DateTime(2022, 1, 1, 12, 30, 5);
  final paymentCompletedTime =
      orderCreationTime.add(const Duration(minutes: 5));
  final pickupTime = paymentCompletedTime.add(const Duration(minutes: 5));
  final orderCompletedTime = pickupTime.add(const Duration(minutes: 5));

  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    'OrderStatusHeader',
    () {
      Future<void> pumpWidgetForTest(
        WidgetTester tester, {
        required String orderId,
        required DateTime orderCreationTime,
        required OrderStatus orderStatus,
        DateTime? estimatedArrivalTime,
        required DateTime? paymentCompletedTime,
        required DateTime? pickupTime,
        required DateTime? orderCompletedTime,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OrderStatusHeader(
                orderId: orderId,
                orderCreationTime: orderCreationTime,
                orderStatus: orderStatus,
                estimatedArrivalTime: estimatedArrivalTime,
                paymentCompletedTime: paymentCompletedTime,
                pickupTime: pickupTime,
                orderCompletedTime: orderCompletedTime,
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
            paymentCompletedTime: paymentCompletedTime,
            pickupTime: null,
            orderCompletedTime: null,
          );

          expect(find.text(orderId), findsOneWidget);
          expect(
            find.text(dateFormat.format(orderCreationTime)),
            findsOneWidget,
          );
          expect(find.byType(DeliveryProgressBar), findsOneWidget);
          expect(find.byType(DeliveryTimeRemaining), findsOneWidget);

          // expect timestamp
          expect(find.text(paymentCompletedTime.formatHm()), findsOneWidget);
          expect(find.text(pickupTime.formatHm()), findsNothing);
          expect(find.text(orderCompletedTime.formatHm()), findsNothing);
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
            paymentCompletedTime: paymentCompletedTime,
            pickupTime: pickupTime,
            orderCompletedTime: null,
          );

          expect(find.text(orderId), findsOneWidget);
          expect(
            find.text(dateFormat.format(orderCreationTime)),
            findsOneWidget,
          );
          expect(find.byType(DeliveryProgressBar), findsOneWidget);
          expect(find.byType(OrderStatusCaption), findsOneWidget);
          expect(find.byType(DeliveryTimeRemaining), findsOneWidget);

          // expect timestamp
          expect(find.text(paymentCompletedTime.formatHm()), findsOneWidget);
          expect(find.text(pickupTime.formatHm()), findsOneWidget);
          expect(find.text(orderCompletedTime.formatHm()), findsNothing);
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
            paymentCompletedTime: paymentCompletedTime,
            pickupTime: pickupTime,
            orderCompletedTime: orderCompletedTime,
          );

          expect(find.text(orderId), findsOneWidget);
          expect(
            find.text(dateFormat.format(orderCreationTime)),
            findsOneWidget,
          );
          expect(find.byType(DeliveryProgressBar), findsOneWidget);
          expect(find.byType(OrderStatusCaption), findsOneWidget);
          expect(find.byType(DeliveryTimeRemaining), findsNothing);

          // expect timestamp
          expect(find.text(paymentCompletedTime.formatHm()), findsOneWidget);
          expect(find.text(pickupTime.formatHm()), findsOneWidget);
          expect(find.text(orderCompletedTime.formatHm()), findsOneWidget);
        },
      );

      // TODO: split into different test cases. Not recommended to have control flow inside test
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
              paymentCompletedTime: null,
              pickupTime: null,
              orderCompletedTime: null,
            );

            expect(find.text(orderId), findsOneWidget);
            expect(
              find.text(dateFormat.format(orderCreationTime)),
              findsOneWidget,
            );
            expect(find.byType(DeliveryProgressBar), findsNothing);
            expect(find.byType(OrderStatusCaption), findsNothing);
            expect(find.byType(DeliveryTimeRemaining), findsNothing);

            // expect timestamp
            expect(find.text(paymentCompletedTime.formatHm()), findsNothing);
            expect(find.text(pickupTime.formatHm()), findsNothing);
            expect(find.text(orderCompletedTime.formatHm()), findsNothing);
          }
        },
      );
    },
  );
}
