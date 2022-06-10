import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/domain/domains.dart';
import 'package:storefront_app/features/order/widgets/order_history/list.dart';

import '../../../../../test_commons/utils/locale_setup.dart';
import '../../../../../test_commons/utils/sample_order_models.dart';
import '../../../../src/mock_navigator.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpWidgetForTest({
    required StackRouter router,
    required List<OrderModel> orders,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: StackRouterScope(
          stateHash: 0,
          controller: router,
          child: Scaffold(
            body: OrderHistoryList(orders: orders),
          ),
        ),
      ),
    );
  }
}

void main() {
  late StackRouter router;

  setUpAll(() {
    router = MockStackRouter();

    // Router stubs
    registerFallbackValue(FakePageRouteInfo());
    when(() => router.push(any())).thenAnswer((_) async => null);

    setUpLocaleInjection();
  });

  group('[OrderHistoryList]', () {
    testWidgets(
      'should create a [OrderHistoryListItem] for every '
      '[OrderModel]. Clicking on list item '
      'will push route for [OrderDetailsPage]',
      (tester) async {
        final orders = sampleOrderModels;
        await tester.pumpWidgetForTest(router: router, orders: orders);

        for (int i = 0; i < orders.length; i++) {
          // Ensure OrderHistoryListItem is created for every model
          final finderListItem = find.byKey(
            ValueKey(OrderHistoryListKeys.listItem(i)),
            skipOffstage: false,
          );

          expect(finderListItem, findsOneWidget);

          // Tapping on list item should push route for OrderDetailsPage
          await tester.ensureVisible(finderListItem);
          await tester.tap(finderListItem);
          await tester.pumpAndSettle();
        }

        // Every button tap should result in a new route pushed
        final capturedRoutes = verify(() => router.push(captureAny())).captured;

        expect(capturedRoutes.length, orders.length);

        // Expect routes are pushed with appropriate OrderModel as an argument
        for (int i = 0; i < capturedRoutes.length; i++) {
          final route =
              capturedRoutes[i] as PageRouteInfo<OrderDetailsRouteArgs>;

          expect(route, isA<OrderDetailsRoute>());
          final args = route.args;
          expect(args, isNotNull);
          expect(args!.order, orders[i]);
        }
      },
    );
  });
}
