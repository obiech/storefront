import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/dropezy_icons.dart';
import 'package:storefront_app/core/utils/build_context.ext.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';
import 'package:storefront_app/features/order/widgets/order_details/status_header/widget.dart';

import '../../../../../../../test_commons/utils/locale_setup.dart';

typedef ExpectedColor = Color Function(BuildContext context);

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  /// Setup widget to be tested and expectations
  Future<void> testFn({
    required OrderStatus orderStatus,
    required ExpectedColor colorForInProcess,
    required ExpectedColor colorForInDelivery,
    required ExpectedColor colorForArrived,
  }) async {
    final BuildContext ctx = await pumpWidgetForTest(orderStatus);

    final textInProcess = firstWidget(
      find.text(ctx.res.strings.inProcess),
    ) as Text;

    final iconInProcess = getIconWidget(DropezyIcons.package);

    final textInDelivery = firstWidget(
      find.text(ctx.res.strings.inDelivery),
    ) as Text;

    final iconInDelivery = getIconWidget(DropezyIcons.delivery);

    final textArrived = firstWidget(
      find.text(ctx.res.strings.arrived),
    ) as Text;

    final iconArrived = getIconWidget(DropezyIcons.pin);

    expect(textInProcess.style?.color, colorForInProcess.call(ctx));
    expect(iconInProcess.color, colorForInProcess.call(ctx));

    expect(textInDelivery.style?.color, colorForInDelivery.call(ctx));
    expect(iconInDelivery.color, colorForInDelivery.call(ctx));

    expect(textArrived.style?.color, colorForArrived.call(ctx));
    expect(iconArrived.color, colorForArrived.call(ctx));
  }

  Future<BuildContext> pumpWidgetForTest(OrderStatus orderStatus) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              ctx = context;
              return DeliveryProgressBar(orderStatus: orderStatus);
            },
          ),
        ),
      ),
    );

    return ctx;
  }

  Icon getIconWidget(IconData iconData) => firstWidget(
        find.byWidgetPredicate(
          (widget) => widget is Icon && widget.icon == iconData,
        ),
      );
}

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    'DeliveryProgressBar',
    () {
      testWidgets(
        'behavior for [OrderStatus.paid]',
        (tester) async {
          await tester.testFn(
            orderStatus: OrderStatus.paid,
            colorForInProcess: (ctx) => ctx.res.colors.green,
            colorForInDelivery: (ctx) => ctx.res.colors.grey3,
            colorForArrived: (ctx) => ctx.res.colors.grey3,
          );
        },
      );

      testWidgets(
        'behavior for [OrderStatus.inDelivery]',
        (tester) async {
          await tester.testFn(
            orderStatus: OrderStatus.inDelivery,
            colorForInProcess: (ctx) => ctx.res.colors.green,
            colorForInDelivery: (ctx) => ctx.res.colors.green,
            colorForArrived: (ctx) => ctx.res.colors.grey3,
          );
        },
      );
      testWidgets(
        'behavior for [OrderStatus.arrived]',
        (tester) async {
          await tester.testFn(
            orderStatus: OrderStatus.arrived,
            colorForInProcess: (ctx) => ctx.res.colors.green,
            colorForInDelivery: (ctx) => ctx.res.colors.green,
            colorForArrived: (ctx) => ctx.res.colors.green,
          );
        },
      );
    },
  );
}
