import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpDropezyChip({
    required DropezyChip Function(BuildContext) builder,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: builder,
        ),
      ),
    );
  }
}

void main() {
  testWidgets(
    '[DropezyChip] should display passed-in label and leading Widget',
    (tester) async {
      await tester.pumpDropezyChip(
        builder: (context) => const DropezyChip(
          label: 'Test',
          backgroundColor: Colors.white,
          leading: Icon(Icons.abc),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Icon && widget.icon == Icons.abc,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    '[DropezyChip.deliveryDuration] should display a delivery icon and '
    'number of minutes',
    (tester) async {
      late BuildContext ctx;
      await tester.pumpDropezyChip(
        builder: (context) {
          ctx = context;
          return DropezyChip.deliveryDuration(
            res: ctx.res,
            minutes: 10,
          );
        },
      );

      // Should find delivery icon painted with blue color
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              widget.icon == DropezyIcons.delivery &&
              widget.color == ctx.res.colors.blue,
        ),
        findsOneWidget,
      );

      // Should find number of minutes
      expect(find.text(ctx.res.strings.minutes(10)), findsOneWidget);
    },
  );
}
