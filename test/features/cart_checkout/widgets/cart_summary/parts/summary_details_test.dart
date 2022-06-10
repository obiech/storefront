import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../commons.dart';
import '../../../../../src/mock_navigator.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  group('Payment Summary Badge', () {
    testWidgets(
        'should not display item count badge '
        'when there are no items in cart', (WidgetTester tester) async {
      /// act
      await tester.pumpCartSummary();

      /// assert
      expect(find.byType(CircleAvatar), findsNothing);
    });

    testWidgets(
        'should display item count badge '
        'when there is one or more items in cart', (WidgetTester tester) async {
      const itemCount = 3;

      /// act
      await tester.pumpCartSummary(
        itemCount: itemCount,
      );

      /// assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text(itemCount.toString()), findsOneWidget);
    });

    testWidgets(
        'should display 9+ in item count badge '
        'when there are more than 9 items in cart',
        (WidgetTester tester) async {
      /// act
      await tester.pumpCartSummary(itemCount: 20);

      /// assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('9+'), findsOneWidget);
    });
  });

  group('Payment Summary Discount', () {
    testWidgets(
        'should not display slashed sub-total '
        'when there is no discount', (WidgetTester tester) async {
      /// arrange
      const subTotal = '23092400';

      /// act
      await tester.pumpCartSummary(
        subTotal: subTotal,
      );

      /// assert
      expect(
        find.text(subTotal.toCurrency()),
        findsNothing,
      );
    });

    testWidgets(
        'should display slashed sub-total '
        'when there is a discount', (WidgetTester tester) async {
      /// arrange
      const subTotal = '23092400';

      /// act
      await tester.pumpCartSummary(
        subTotal: subTotal,
        hasDiscount: true,
      );

      /// assert
      expect(
        find.text(subTotal.toCurrency()),
        findsOneWidget,
      );
    });
  });

  group('Payment Summary Total', () {
    testWidgets('should show cart summary total', (WidgetTester tester) async {
      /// arrange
      const total = '23092400';

      /// act
      await tester.pumpCartSummary(total: total);

      /// assert
      expect(
        find.text(total.toCurrency()),
        findsOneWidget,
      );
    });
  });

  group('Payment Summary View Cart Button', () {
    testWidgets(
        'should go to cart checkout '
        'when isLoading is true '
        'and "View Cart" button is tapped ', (WidgetTester tester) async {
      // Routing
      final stackRouter = MockStackRouter();
      when(() => stackRouter.push(any())).thenAnswer((_) async => null);

      /// act
      await tester.pumpCartSummary(stackRouter: stackRouter);

      /// assert
      final viewCartButtonFinder = find.byType(DropezyButton);
      expect(
        viewCartButtonFinder,
        findsOneWidget,
      );

      await tester.tap(viewCartButtonFinder);
      await tester.pump();

      final capturedRoutes =
          verify(() => stackRouter.push(captureAny())).captured;

      // there should only be one route that's being pushed
      expect(capturedRoutes.length, 1);

      final routeInfo = capturedRoutes.first as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<CartCheckoutRoute>());
    });

    testWidgets(
        'should NOT go to cart checkout '
        'when "View Cart" button is tapped '
        'and loading', (WidgetTester tester) async {
      // Routing
      final stackRouter = MockStackRouter();
      when(() => stackRouter.push(any())).thenAnswer((_) async => null);

      /// act
      await tester.pumpCartSummary(isLoading: true, stackRouter: stackRouter);

      /// assert
      final viewCartButtonFinder = find.byType(DropezyButton);
      expect(
        viewCartButtonFinder,
        findsOneWidget,
      );

      await tester.tap(viewCartButtonFinder);
      await tester.pump();

      verifyNever(() => stackRouter.push(captureAny())).captured;
    });
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCartSummary({
    bool isLoading = false,
    String subTotal = '0000',
    bool hasDiscount = false,
    String total = '0000',
    int itemCount = 0,
    StackRouter? stackRouter,
  }) async {
    await pumpWidget(
      stackRouter != null
          ? StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: MaterialApp(
                home: Scaffold(
                  body: CartSummaryDetails(
                    isLoading: isLoading,
                    subTotal: subTotal,
                    hasDiscount: hasDiscount,
                    total: total,
                    itemCount: itemCount,
                  ),
                ),
              ),
            )
          : MaterialApp(
              home: Scaffold(
                body: CartSummaryDetails(
                  isLoading: isLoading,
                  subTotal: subTotal,
                  hasDiscount: hasDiscount,
                  total: total,
                  itemCount: itemCount,
                ),
              ),
            ),
    );
  }
}
