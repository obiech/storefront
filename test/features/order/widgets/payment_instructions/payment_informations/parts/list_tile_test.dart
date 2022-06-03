import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../../../test_commons/finders/payment_instructions/list_tile_finders.dart';
import '../../../../../../../test_commons/fixtures/order/order_models.dart';
import '../../../../../../src/mock_navigator.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpPaymentMethodTile() async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Material(
              child: InformationsTile.paymentMethod(
                res: context.res,
                paymentMethod: '',
              ),
            );
          },
        ),
      ),
    );
    return ctx;
  }

  Future<BuildContext> pumpVirtualAccountTile({
    required String virtualAccount,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Material(
              child: InformationsTile.virtualAccount(
                ctx: ctx,
                res: context.res,
                virtualAccount: virtualAccount,
              ),
            );
          },
        ),
      ),
    );
    return ctx;
  }

  Future<BuildContext> pumpTotalBillTile({
    required OrderModel order,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Material(
              child: InformationsTile.totalBill(
                res: context.res,
                amount: order.total,
              ),
            );
          },
        ),
      ),
    );
    return ctx;
  }
}

void main() {
  late StackRouter stackRouter;

  setUp(() {
    stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((invocation) async => null);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  group('[InformationsTile]', () {
    testWidgets(
      'Should show header text and subtitle with logo and text '
      'when type is [InformationsTile.paymentMethod]',
      (tester) async {
        final context = await tester.pumpPaymentMethodTile();

        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderHeader,
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<Text>(ListTileFinder.finderHeader).data,
          equals(context.res.strings.paymentMethod),
        );

        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderSubtitleLogo,
          ),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderSubtitleText,
          ),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderButton,
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Should show header, subtitle, and text button with icon '
      'when type is [InformationsTile.virtualAccount]',
      (tester) async {
        const expectedVANumber = '123456789';

        final context = await tester.pumpVirtualAccountTile(
          virtualAccount: expectedVANumber,
        );
        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderHeader,
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<Text>(ListTileFinder.finderHeader).data,
          equals(context.res.strings.virtualAccountNumber),
        );
        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderSubtitleText,
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<Text>(ListTileFinder.finderSubtitleText).data,
          equals(expectedVANumber),
        );

        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderButton,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Should show header, subtitle, and text button '
      'when type is [InformationsTile.totalBill]',
      (tester) async {
        final context = await tester.pumpTotalBillTile(
          order: orderAwaitingPayment,
        );
        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderHeader,
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<Text>(ListTileFinder.finderHeader).data,
          equals(context.res.strings.totalBill),
        );
        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderSubtitleText,
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<Text>(ListTileFinder.finderSubtitleText).data,
          equals(orderAwaitingPayment.total.toCurrency()),
        );
        expect(
          find.descendant(
            of: ListTileFinder.finderTile,
            matching: ListTileFinder.finderButton,
          ),
          findsOneWidget,
        );
      },
    );
  });
}
