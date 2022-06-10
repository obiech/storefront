import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/utils/locale_setup.dart';
import '../../../../../test_commons/utils/sample_order_models.dart';
import '../../../../src/mock_navigator.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<void> pumpOrderDetailsPage({
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
      testWidgets(
        'should show [OrderDetailsView] '
        'when order status is not Awaiting Payment',
        (tester) async {
          final orders = sampleOrderModels;
          for (int i = 0; i < orders.length; i++) {
            await tester.pumpOrderDetailsPage(order: orders[i]);

            expect(find.byType(OrderDetailsView), findsOneWidget);
          }
        },
      );
    },
  );
}
