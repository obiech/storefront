import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../mocks.dart';

void main() {
  late CartBloc bloc;

  late CartModel cartModel;

  setUpAll(() {
    cartModel = mockCartModel;
  });

  setUp(() {
    bloc = MockCartBloc();
  });

  tearDown(() {
    bloc.close();
  });

  testWidgets(
      'should display [CartSummaryDetails] widget with skeleton '
      'when calculating cart summary', (WidgetTester tester) async {
    /// arrange
    when(() => bloc.state).thenAnswer((_) => CartLoaded.loading(cartModel));

    /// act
    await tester.pumpCartSummary(bloc);
    await tester.pump();

    /// assert
    expect(_loadingFinder, findsOneWidget);

    tester.testCartModelValues(cartModel, true);
  });

  testWidgets(
      'should display [CartSummaryDetails] widget with skeleton '
      'when loading cart', (WidgetTester tester) async {
    /// arrange
    when(() => bloc.state).thenAnswer((_) => const CartLoading());

    /// act
    await tester.pumpCartSummary(bloc);
    await tester.pump();

    /// assert
    expect(_loadingFinder, findsOneWidget);

    final cartSummary =
        tester.firstWidget<CartSummaryDetails>(_cartSummaryFinder);
    expect(cartSummary.isLoading, true);
    expect(cartSummary.total, '000');
    expect(cartSummary.subTotal, '000');
    expect(cartSummary.itemCount, 0);
  });

  testWidgets(
      'should display [CartSummaryDetails] widget without skeleton '
      'when not calculating cart summary', (WidgetTester tester) async {
    /// arrange
    when(() => bloc.state).thenAnswer((_) => CartLoaded.success(cartModel));

    /// act
    await tester.pumpCartSummary(bloc);

    /// assert
    expect(_cartSummaryFinder, findsOneWidget);
    expect(_loadingFinder, findsNothing);

    tester.testCartModelValues(cartModel, false);
  });
}

/// Finders
final _cartSummaryFinder = find.byType(CartSummaryDetails);
final _loadingFinder = find.ancestor(
  of: _cartSummaryFinder,
  matching: find.byType(SkeletonItem),
);

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCartSummary(CartBloc bloc) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => bloc,
        child: const MaterialApp(
          home: Scaffold(
            body: CartSummary(),
          ),
        ),
      ),
    );
  }

  void testCartModelValues(CartModel cartModel, bool isLoading) {
    final cartSummary = firstWidget<CartSummaryDetails>(_cartSummaryFinder);
    expect(cartSummary.isLoading, isLoading);
    expect(cartSummary.subTotal, cartModel.paymentSummary.subTotal);
    expect(cartSummary.total, cartModel.paymentSummary.total);
    expect(cartSummary.itemCount, cartModel.items.length);
  }
}
