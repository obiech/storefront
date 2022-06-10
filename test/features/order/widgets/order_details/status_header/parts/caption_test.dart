import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/utils/build_context.ext.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';
import 'package:storefront_app/features/order/widgets/order_details/status_header/widget.dart';

import '../../../../../../../test_commons/utils/locale_setup.dart';

void main() {
  /// Pumps [OrderStatusCaption] widget and tests for displayed text.
  ///
  /// Pass the expected localized string in [expectedText]
  /// that will be shown for [status].
  Future<void> testFn({
    required WidgetTester tester,
    required String Function(BuildContext) expectedText,
    required OrderStatus status,
  }) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return OrderStatusCaption(
                orderStatus: status,
              );
            },
          ),
        ),
      ),
    );

    final expected = expectedText(context);

    expect(
      find.text(expected),
      findsOneWidget,
    );
  }

  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    '[OrderStatusCaption] should display text based on order status.',
    () {
      testWidgets(
        '[OrderStatus.paid]',
        (tester) async {
          await testFn(
            tester: tester,
            expectedText: (context) =>
                context.res.strings.captionOrderInProcess,
            status: OrderStatus.paid,
          );
        },
      );

      testWidgets(
        '[OrderStatus.inDelivery]',
        (tester) async {
          await testFn(
            tester: tester,
            expectedText: (context) =>
                context.res.strings.captionOrderInDelivery,
            status: OrderStatus.inDelivery,
          );
        },
      );

      testWidgets(
        '[OrderStatus.arrived]',
        (tester) async {
          await testFn(
            tester: tester,
            expectedText: (context) =>
                context.res.strings.captionOrderHasArrived,
            status: OrderStatus.arrived,
          );
        },
      );
    },
  );
}
