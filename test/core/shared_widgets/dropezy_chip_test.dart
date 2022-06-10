import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

import '../../../test_commons/utils/locale_setup.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> testFn({
    required DropezyChip Function(BuildContext) builder,
    required String Function(BuildContext) expectedText,
    Finder Function(BuildContext)? leadingFinder,
  }) async {
    final ctx = await pumpDropezyChip(builder: builder);

    expect(find.text(expectedText(ctx)), findsOneWidget);

    if (leadingFinder != null) {
      expect(leadingFinder(ctx), findsOneWidget);
    }
  }

  Future<BuildContext> pumpDropezyChip({
    required DropezyChip Function(BuildContext) builder,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return builder(context);
          },
        ),
      ),
    );

    return ctx;
  }
}

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
    '[DropezyChip] should display passed-in label and leading Widget',
    (tester) async {
      await tester.testFn(
        builder: (context) => const DropezyChip(
          label: 'Test',
          backgroundColor: Colors.white,
          leading: Icon(Icons.abc),
        ),
        expectedText: (_) => 'Test',
        leadingFinder: (_) => find.byWidgetPredicate(
          (widget) => widget is Icon && widget.icon == Icons.abc,
        ),
      );
    },
  );

  testWidgets(
    '[DropezyChip.deliveryDuration] should display a delivery icon and '
    'number of minutes',
    (tester) async {
      await tester.testFn(
        builder: (context) => DropezyChip.deliveryDuration(
          res: context.res,
          minutes: 10,
        ),
        expectedText: (context) => context.res.strings.minutes(10),
        leadingFinder: (context) => find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              widget.icon == DropezyIcons.delivery &&
              widget.color == context.res.colors.blue,
        ),
      );
    },
  );

  testWidgets(
    '[DropezyChip.awaitingPayment] should display text Awaiting Payment',
    (tester) async {
      await tester.testFn(
        builder: (context) => DropezyChip.awaitingPayment(res: context.res),
        expectedText: (context) => context.res.strings.awaitingPayment,
      );
    },
  );

  testWidgets(
    '[DropezyChip.inProcess] should display text In Process',
    (tester) async {
      await tester.testFn(
        builder: (context) => DropezyChip.inProcess(res: context.res),
        expectedText: (context) => context.res.strings.inProcess,
      );
    },
  );

  testWidgets(
    '[DropezyChip.inDelivery] should display text In Delivery',
    (tester) async {
      await tester.testFn(
        builder: (context) => DropezyChip.inDelivery(res: context.res),
        expectedText: (context) => context.res.strings.inDelivery,
      );
    },
  );

  testWidgets(
    '[DropezyChip.arrivedAtDestination] should display text Arrived At Destination',
    (tester) async {
      await tester.testFn(
        builder: (context) =>
            DropezyChip.arrivedAtDestination(res: context.res),
        expectedText: (context) => context.res.strings.arrivedAtDestination,
      );
    },
  );

  testWidgets(
    '[DropezyChip.cancelled] should display text Cancelled',
    (tester) async {
      await tester.testFn(
        builder: (context) => DropezyChip.cancelled(res: context.res),
        expectedText: (context) => context.res.strings.cancelled,
      );
    },
  );

  testWidgets(
    '[DropezyChip.failed] should display text Failed',
    (tester) async {
      await tester.testFn(
        builder: (context) => DropezyChip.failed(res: context.res),
        expectedText: (context) => context.res.strings.failed,
      );
    },
  );

  testWidgets(
    '[DropezyChip.unspecified] should display text Unspecified',
    (tester) async {
      await tester.testFn(
        builder: (context) => DropezyChip.unspecified(res: context.res),
        expectedText: (context) => context.res.strings.unspecified,
      );
    },
  );
}
