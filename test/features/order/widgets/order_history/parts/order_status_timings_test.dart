import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/utils/datetime.ext.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';
import 'package:storefront_app/features/order/widgets/order_history/list.dart';

import '../../../../../../test_commons/fixtures/order/order_models.dart';

void main() {
  group('[OrderStatusTimings]', () {
    Future<void> pumpOrderStatusTimingsWidget({
      required WidgetTester tester,
      required OrderModel order,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderStatusTimings(
              order: order,
            ),
          ),
        ),
      );
    }

    testWidgets(
      'displays a hh:mm:ss countdown timer when status is waiting for payment',
      (tester) async {
        final orderToTest = orderAwaitingPayment;
        await pumpOrderStatusTimingsWidget(
          tester: tester,
          order: orderToTest,
        );

        final countdownText = orderToTest.paymentExpiryTime!
            .getPrettyTimeDifference(TimeDiffFormat.hhmmss, DateTime.now());

        expect(find.text(countdownText), findsOneWidget);

        // TODO (leovinsen): test using clock package to test countdown
        // late String prevCountdown;

        // for (int i = 0; i < 60; i++) {
        //   await tester.pump(const Duration(seconds: 1));
        //   final countdownText = orderToTest.paymentExpiryTime!
        //       .getPrettyTimeDifference(TimeDiffFormat.hhmmss, DateTime.now());

        //   if (i > 0) {
        //     // Ensure current countdown is different from last one
        //     expect(prevCountdown, isNot(equals(countdownText)));
        //   }

        //   // Expect currently displayed text is countdown obtained from
        //   // DateTime extension
        //   expect(find.text(countdownText), findsOneWidget);

        //   prevCountdown = countdownText;
        // }
      },
    );

    testWidgets(
      'displays a mm:ss countdown timer when status is in delivery',
      (tester) async {
        final orderToTest = orderPaid;
        await pumpOrderStatusTimingsWidget(
          tester: tester,
          order: orderToTest,
        );

        final countdownText = orderToTest.estimatedArrivalTime!
            .getPrettyTimeDifference(TimeDiffFormat.mmss, DateTime.now());

        expect(find.text(countdownText), findsOneWidget);

        // TODO (leovinsen): test using clock package to test countdown
        // late String prevCountdown;

        // for (int i = 0; i < 60; i++) {
        //   await tester.pump(const Duration(seconds: 1));
        //   final countdownText = orderToTest.paymentExpiryTime!
        //       .getPrettyTimeDifference(TimeDiffFormat.hhmmss, DateTime.now());

        //   if (i > 0) {
        //     // Ensure current countdown is different from last one
        //     expect(prevCountdown, isNot(equals(countdownText)));
        //   }

        //   // Expect currently displayed text is countdown obtained from
        //   // DateTime extension
        //   expect(find.text(countdownText), findsOneWidget);

        //   prevCountdown = countdownText;
        // }
      },
    );

    testWidgets(
      'displays a mm:ss countdown timer when status is paid',
      (tester) async {
        final orderToTest = orderInDelivery;
        await pumpOrderStatusTimingsWidget(
          tester: tester,
          order: orderToTest,
        );

        final countdownText = orderToTest.estimatedArrivalTime!
            .getPrettyTimeDifference(TimeDiffFormat.mmss, DateTime.now());

        expect(find.text(countdownText), findsOneWidget);

        // TODO (leovinsen): test using clock package to test countdown
        // late String prevCountdown;

        // for (int i = 0; i < 60; i++) {
        //   await tester.pump(const Duration(seconds: 1));
        //   final countdownText = orderToTest.paymentExpiryTime!
        //       .getPrettyTimeDifference(TimeDiffFormat.hhmmss, DateTime.now());

        //   if (i > 0) {
        //     // Ensure current countdown is different from last one
        //     expect(prevCountdown, isNot(equals(countdownText)));
        //   }

        //   // Expect currently displayed text is countdown obtained from
        //   // DateTime extension
        //   expect(find.text(countdownText), findsOneWidget);

        //   prevCountdown = countdownText;
        // }
      },
    );
  });
}
