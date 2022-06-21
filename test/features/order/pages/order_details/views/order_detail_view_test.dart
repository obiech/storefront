import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../../test_commons/fixtures/order/order_models.dart';
import '../../../../../../test_commons/utils/locale_setup.dart';
import '../../../../../../test_commons/utils/sample_order_models.dart';
import '../../../../../src/mock_navigator.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<void> pumpOrderDetailsView({
    required OrderModel order,
    StackRouter? stackRouter,
  }) async {
    await pumpWidget(
      stackRouter != null
          ? StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: MaterialApp(
                home: Scaffold(
                  body: OrderDetailsPage(order: order),
                ),
              ),
            )
          : MaterialApp(
              home: Scaffold(
                body: OrderDetailsPage(order: order),
              ),
            ),
    );
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

    setUpLocaleInjection();
  });
  group(
    'OrderDetailsPage',
    () {
      final finderStatusHeader = find.byType(
        OrderStatusHeader,
        skipOffstage: false,
      );
      final finderDetailsSection = find.byType(
        OrderDetailsSection,
        skipOffstage: false,
      );
      final finderPaymentSummary = find.byType(
        OrderPaymentSummary,
        skipOffstage: false,
      );
      final finderDriverAndRecipientSection = find.byType(
        DriverAndRecipientSection,
        skipOffstage: false,
      );
      final finderContactSupportButton = find.byType(
        ContactSupportButton,
        skipOffstage: false,
      );
      final finderDeliveryAddressDetail = find.byType(
        DeliveryAddressDetail,
        skipOffstage: false,
      );

      testWidgets(
        'for [OrderStatus.paid] should show order status header, '
        'list of purchased products, transaction summary, '
        'and a button to contact support',
        (tester) async {
          await tester.pumpOrderDetailsView(order: orderPaid);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderDeliveryAddressDetail, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsNothing);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );

      testWidgets(
        'for [OrderStatus.inDelivery] should show order status header, '
        'list of purchased products, transaction summary, driver information '
        'and a button to contact support',
        (tester) async {
          await tester.pumpOrderDetailsView(order: orderInDelivery);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderDeliveryAddressDetail, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsOneWidget);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );

      testWidgets(
        'for [OrderStatus.arrived] should show order status header, '
        'list of purchased products, transaction summary, driver and '
        'recipient information, and a button to contact support',
        (tester) async {
          await tester.pumpOrderDetailsView(order: orderArrived);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderDeliveryAddressDetail, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsOneWidget);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );
      testWidgets(
        'should navigate to Help Page '
        'when Support Button is tapped',
        (tester) async {
          await tester.pumpOrderDetailsView(
            order: orderArrived,
            stackRouter: stackRouter,
          );
          await tester.tap(finderContactSupportButton);
          await tester.pumpAndSettle();

          final capturedRoutes =
              verify(() => stackRouter.push(captureAny())).captured;

          // there should only be one route that's being pushed
          expect(capturedRoutes.length, 1);

          final routeInfo = capturedRoutes.first as PageRouteInfo;

          // expecting the right route being pushed
          expect(routeInfo, isA<HelpRoute>());
        },
      );

      testWidgets(
        'should not shown Pay Now Button '
        'when Order status is not awaiting payment',
        (tester) async {
          final orders = fakeOrderModels;
          for (int i = 0; i < orders.length; i++) {
            await tester.pumpOrderDetailsView(order: orders[i]);

            expect(find.byType(PayNowButton), findsNothing);
          }
        },
      );
    },
  );
}
