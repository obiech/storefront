import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../test_commons/fixtures/address/delivery_address_models.dart'
    as address_fixtures;
import '../../../commons.dart';
import '../../../src/mock_navigator.dart';

void main() {
  late StackRouter stackRouter;

  setUp(() {
    stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);
  });

  setUpAll(() {
    setUpLocaleInjection();
    registerFallbackValue(FakePageRouteInfo());
  });

  group(
    '[DeliveryAddressDetail]',
    () {
      final address = address_fixtures.sampleDeliveryAddressList[0];
      // TODO (leovinsen): Expand tests for common elements

      testWidgets(
        'should display delivery estimation '
        'when [showDeliveryEstimation] is set to true',
        (tester) async {
          final ctx = await tester.pumpDeliveryAddressDetail(address: address);

          final finderChip = find.byType(DropezyChip);
          expect(finderChip, findsOneWidget);
          expect(
            find.descendant(
              of: finderChip,
              matching: find.text(ctx.res.strings.minutes(15)),
            ),
            findsOneWidget,
          );
        },
      );

      group(
        'when [enableAddressSelection] is set to true',
        () {
          testWidgets(
            'should display icon button with chevron right icon ',
            (WidgetTester tester) async {
              final ctx =
                  await tester.pumpDeliveryAddressDetail(address: address);

              final iconButton =
                  tester.widget<IconButton>(find.byType(IconButton));

              final icon = iconButton.icon as Icon;

              expect(icon.icon, DropezyIcons.chevron_right);
              expect(icon.color, ctx.res.colors.black);
            },
          );

          testWidgets(
            'should navigate to Change Address page '
            'when icon button is tapped',
            (WidgetTester tester) async {
              await tester.pumpDeliveryAddressDetail(
                address: address,
                stackRouter: stackRouter,
              );

              await tester.tap(find.byType(IconButton));
              await tester.pumpAndSettle();

              final capturedRoutes =
                  verify(() => stackRouter.push(captureAny())).captured;

              // there should only be one route that's being pushed
              expect(capturedRoutes.length, 1);

              final routeInfo = capturedRoutes.first as PageRouteInfo;

              // expecting the right route being pushed
              expect(routeInfo, isA<ChangeAddressRoute>());
            },
          );
        },
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpDeliveryAddressDetail({
    required DeliveryAddressModel address,
    StackRouter? stackRouter,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: DeliveryAddressDetail(
                heading: '',
                address: address,
                showDeliveryEstimation: true,
                enableAddressSelection: true,
              ),
            );
          },
        ),
      ).withRouterScope(stackRouter),
    );

    return ctx;
  }
}
