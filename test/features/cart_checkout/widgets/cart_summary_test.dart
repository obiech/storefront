import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../src/mock_navigator.dart';
import '../mocks.dart';

void main() {
  late CartBloc bloc;

  const cartModel = mockCartModel;

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  setUp(() {
    bloc = MockCartBloc();
  });

  group('Payment Summary Badge', () {
    testWidgets(
        'should not display item count badge '
        'when there are no items in cart', (WidgetTester tester) async {
      /// arrange
      when(() => bloc.state)
          .thenAnswer((_) => CartLoaded.success(cartModel.copyWith(items: [])));

      /// act
      await tester.pumpCartSummary(bloc);

      /// assert
      expect(find.byType(CircleAvatar), findsNothing);
    });

    testWidgets(
        'should display item count badge '
        'when there is one or more items in cart', (WidgetTester tester) async {
      /// arrange
      when(() => bloc.state).thenAnswer((_) => CartLoaded.success(cartModel));

      /// act
      await tester.pumpCartSummary(bloc);

      /// assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text(cartModel.items.length.toString()), findsOneWidget);
    });

    testWidgets(
        'should display 9+ in item count badge '
        'when there are more than 9 items in cart',
        (WidgetTester tester) async {
      /// arrange
      when(() => bloc.state).thenAnswer(
        (_) => CartLoaded.success(
          cartModel.copyWith(
            items: List.generate(10, (index) => cartModel.items.first),
          ),
        ),
      );

      /// act
      await tester.pumpCartSummary(bloc);

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
      when(() => bloc.state).thenAnswer(
        (_) => CartLoaded.success(
          cartModel.copyWith(
            paymentSummary: cartModel.paymentSummary.copyWith(
              discount: '000',
              subTotal: subTotal,
            ),
          ),
        ),
      );

      /// act
      await tester.pumpCartSummary(bloc);

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
      const discount = '5000';
      const subTotal = '23092400';
      when(() => bloc.state).thenAnswer(
        (_) => CartLoaded.success(
          cartModel.copyWith(
            paymentSummary: cartModel.paymentSummary.copyWith(
              discount: discount,
              subTotal: subTotal,
            ),
          ),
        ),
      );

      /// act
      await tester.pumpCartSummary(bloc);

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
      when(() => bloc.state).thenAnswer(
        (_) => CartLoaded.success(
          cartModel.copyWith(
            paymentSummary: cartModel.paymentSummary.copyWith(
              total: total,
            ),
          ),
        ),
      );

      /// act
      await tester.pumpCartSummary(bloc);

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
        'when "View Cart" button is tapped', (WidgetTester tester) async {
      // Routing
      final stackRouter = MockStackRouter();
      when(() => stackRouter.push(any())).thenAnswer((_) async => null);

      /// arrange
      when(() => bloc.state).thenAnswer(
        (_) => CartLoaded.success(cartModel),
      );

      /// act
      await tester.pumpCartSummary(bloc, stackRouter: stackRouter);

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
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCartSummary(
    CartBloc bloc, {
    StackRouter? stackRouter,
  }) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => bloc,
        child: stackRouter != null
            ? StackRouterScope(
                controller: stackRouter,
                stateHash: 0,
                child: const MaterialApp(
                  home: Scaffold(
                    body: CartSummary(),
                  ),
                ),
              )
            : const MaterialApp(
                home: Scaffold(
                  body: CartSummary(),
                ),
              ),
      ),
    );
  }
}
