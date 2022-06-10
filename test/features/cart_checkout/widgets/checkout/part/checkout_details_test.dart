import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/blocs/blocs.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/cart_checkout.dart';

import '../../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../mocks.dart';

void main() {
  late CartBloc _cartBloc;
  late CartModel _cartModel;
  late CartModel _cartModelDiscounted;

  setUp(() {
    _cartBloc = MockCartBloc();
    _cartModel = mockCartModel;
    _cartModelDiscounted = mockCartModelDiscounted;
  });

  group('[PriceAmountText]', () {
    testWidgets(
      'should not display [PriceAmountText] '
      'when calculating cart summary',
      (WidgetTester tester) async {
        /// arrange
        when(() => _cartBloc.state)
            .thenAnswer((_) => CartLoaded.loading(_cartModel));

        /// act
        await tester.pumpCartSummary(_cartBloc);

        /// assert
        expect(find.byType(PriceAmountText), findsNothing);
      },
    );

    testWidgets(
      'should display [PriceAmountText] '
      'when not calculating cart summary',
      (WidgetTester tester) async {
        /// arrange
        when(() => _cartBloc.state)
            .thenAnswer((_) => CartLoaded.success(_cartModel));

        /// act
        await tester.pumpCartSummary(_cartBloc);

        /// assert
        expect(find.byType(PriceAmountText), findsOneWidget);
      },
    );
  });

  group('[SlashedAmountText]', () {
    testWidgets(
      'should not display [SlashedAmountText] '
      'when calculating cart summary',
      (WidgetTester tester) async {
        /// arrange
        when(() => _cartBloc.state)
            .thenAnswer((_) => CartLoaded.loading(_cartModelDiscounted));

        /// act
        await tester.pumpCartSummary(_cartBloc);

        /// assert
        expect(find.byType(SlashedAmountText), findsNothing);
      },
    );

    testWidgets(
      'should not display [SlashedAmountText] '
      'when there is no discount',
      (WidgetTester tester) async {
        /// arrange
        when(() => _cartBloc.state)
            .thenAnswer((_) => CartLoaded.success(_cartModel));

        /// act
        await tester.pumpCartSummary(_cartBloc);

        /// assert
        expect(find.byType(SlashedAmountText), findsNothing);
      },
    );

    testWidgets(
      'should display [SlashedAmountText] '
      'when there is a discount',
      (WidgetTester tester) async {
        /// arrange
        when(() => _cartBloc.state)
            .thenAnswer((_) => CartLoaded.success(_cartModelDiscounted));

        /// act
        await tester.pumpCartSummary(_cartBloc);

        /// assert
        expect(find.byType(SlashedAmountText), findsOneWidget);
      },
    );
  });

  group('[CheckoutDetailSkeleton]', () {
    testWidgets(
      'should display [CheckoutDetailSkeleton] '
      'when calculating cart summary',
      (WidgetTester tester) async {
        /// arrange
        when(() => _cartBloc.state)
            .thenAnswer((_) => CartLoaded.loading(_cartModel));

        /// act
        await tester.pumpCartSummary(_cartBloc);

        /// assert
        expect(find.byType(CheckoutDetailSkeleton), findsOneWidget);
      },
    );
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCartSummary(CartBloc cartBloc) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => cartBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: CheckoutDetails(),
          ),
        ),
      ),
    );
  }
}
