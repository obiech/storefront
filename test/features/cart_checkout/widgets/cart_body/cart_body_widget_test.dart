import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/finders/cart/cart_body_widget_finders.dart';
import '../../../../../test_commons/fixtures/cart/cart_models.dart'
    as cart_fixtures;
import '../../mocks.dart';

void main() {
  group(
    '[CartBodyWidget]',
    () {
      late CartBloc cartBloc;

      setUp(() {
        cartBloc = MockCartBloc();
      });

      testWidgets(
        'should display a [CartBodyLoading] '
        'when state is [CartLoading] ',
        (tester) async {
          when(() => cartBloc.state).thenReturn(const CartLoading());

          await tester.pumpCartBody(cartBloc: cartBloc);

          // should display list of cart items
          expect(CartBodyWidgetFinders.cartBodyLoading, findsOneWidget);

          // should not display widgets for success case
          expect(CartBodyWidgetFinders.cartItemsInStock, findsNothing);
          expect(CartBodyWidgetFinders.cartItemsOutOfStock, findsNothing);
          expect(CartBodyWidgetFinders.paymentSummary, findsNothing);
        },
      );

      testWidgets(
        'should display a [CartItemsSection] '
        'and a [OrderPaymentSummary] '
        'when state is [CartLoaded] '
        'and payment summary has been calculated',
        (tester) async {
          const cart = cart_fixtures.mockCartModel;
          when(() => cartBloc.state).thenReturn(CartLoaded.loading(cart));

          await tester.pumpCartBody(cartBloc: cartBloc);

          // should display list of cart items
          // and its contents are based on State's cart
          expect(CartBodyWidgetFinders.cartItemsInStock, findsOneWidget);
          final itemsSection = tester.firstWidget<CartItemsSection>(
            CartBodyWidgetFinders.cartItemsInStock,
          );
          expect(itemsSection.items, cart.inStockItems);

          // should not display list of out-of-stock cart items
          expect(CartBodyWidgetFinders.cartItemsOutOfStock, findsNothing);

          // should display a payment summary
          expect(CartBodyWidgetFinders.paymentSummaryLoading, findsOneWidget);
        },
      );

      testWidgets(
        'should display a [CartItemsSection] for in-stock items '
        'and another [CartItemsSection] for out-of-stock items '
        'and a [OrderPaymentSummary] '
        'when state is [CartLoaded] '
        'and payment summary has been calculated '
        'and cart contains item that is out of stock',
        (tester) async {
          final cart = cart_fixtures.mockCartModelOutOfStock;
          when(() => cartBloc.state).thenReturn(CartLoaded.loading(cart));

          await tester.pumpCartBody(cartBloc: cartBloc);

          // should display list of cart items
          // and its contents are based on State's cart
          expect(CartBodyWidgetFinders.cartItemsInStock, findsOneWidget);
          final itemsSection = tester.firstWidget<CartItemsSection>(
            CartBodyWidgetFinders.cartItemsInStock,
          );
          expect(itemsSection.items, cart.inStockItems);

          // should display list of out-of-stock cart items
          // and its contents based on State's cart
          expect(CartBodyWidgetFinders.cartItemsOutOfStock, findsOneWidget);
          final itemsSectionOutOfStock = tester.firstWidget<CartItemsSection>(
            CartBodyWidgetFinders.cartItemsOutOfStock,
          );
          expect(itemsSectionOutOfStock.items, cart.outOfStockItems);

          // should display a payment summary
          expect(CartBodyWidgetFinders.paymentSummaryLoading, findsOneWidget);
        },
      );

      testWidgets(
        'should display [CartItemsSection] '
        'and a [OrderPaymentSummaryLoading] '
        'when state is [CartLoaded] '
        'and payment summary is being calculated',
        (tester) async {
          const cart = cart_fixtures.mockCartModel;
          when(() => cartBloc.state).thenReturn(CartLoaded.loading(cart));

          await tester.pumpCartBody(cartBloc: cartBloc);

          // should display list of cart items
          // and its contents are based on State's cart
          expect(CartBodyWidgetFinders.cartItemsInStock, findsOneWidget);
          final itemsSection = tester.firstWidget<CartItemsSection>(
            CartBodyWidgetFinders.cartItemsInStock,
          );
          expect(itemsSection.items, cart.inStockItems);

          // should not display list of out-of-stock cart items
          expect(CartBodyWidgetFinders.cartItemsOutOfStock, findsNothing);

          // should display payment summary loading widget
          expect(CartBodyWidgetFinders.paymentSummaryLoading, findsOneWidget);

          // should not display loading or error widget
          expect(CartBodyWidgetFinders.cartBodyLoading, findsNothing);
          expect(CartBodyWidgetFinders.failedToLoad, findsNothing);
        },
      );

      testWidgets(
        'should display a [CartItemsSection] for in-stock items '
        'and another [CartItemsSection] for out-of-stock items '
        'and a [OrderPaymentSummary] '
        'when state is [CartLoaded] '
        'and payment summary is being calculated '
        'and cart contains item that is out of stock',
        (tester) async {
          final cart = cart_fixtures.mockCartModelOutOfStock;
          when(() => cartBloc.state).thenReturn(CartLoaded.loading(cart));

          await tester.pumpCartBody(cartBloc: cartBloc);

          // should display list of cart items
          // and its contents are based on State's cart
          expect(CartBodyWidgetFinders.cartItemsInStock, findsOneWidget);
          final itemsSection = tester.firstWidget<CartItemsSection>(
            CartBodyWidgetFinders.cartItemsInStock,
          );
          expect(itemsSection.items, cart.inStockItems);

          // should display list of out-of-stock cart items
          // and its contents based on State's cart
          expect(CartBodyWidgetFinders.cartItemsOutOfStock, findsOneWidget);
          final itemsSectionOutOfStock = tester.firstWidget<CartItemsSection>(
            CartBodyWidgetFinders.cartItemsOutOfStock,
          );
          expect(itemsSectionOutOfStock.items, cart.outOfStockItems);

          // should display payment summary loading widget
          expect(CartBodyWidgetFinders.paymentSummaryLoading, findsOneWidget);

          // should not display loading or error widget
          expect(CartBodyWidgetFinders.cartBodyLoading, findsNothing);
          expect(CartBodyWidgetFinders.failedToLoad, findsNothing);
        },
      );

      testWidgets(
        'should display an error Widget '
        'when state is [CartFailedToLoad]',
        (tester) async {
          when(() => cartBloc.state).thenReturn(const CartFailedToLoad());

          await tester.pumpCartBody(cartBloc: cartBloc);

          // should display an error widget
          expect(CartBodyWidgetFinders.failedToLoad, findsOneWidget);

          // should not display widgets for success case
          expect(CartBodyWidgetFinders.cartItemsInStock, findsNothing);
          expect(CartBodyWidgetFinders.cartItemsOutOfStock, findsNothing);
          expect(CartBodyWidgetFinders.paymentSummary, findsNothing);
        },
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCartBody({
    required CartBloc cartBloc,
  }) async {
    await pumpWidget(
      BlocProvider<CartBloc>(
        create: (context) => cartBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: CartBodyWidget(),
          ),
        ),
      ),
    );
  }
}
