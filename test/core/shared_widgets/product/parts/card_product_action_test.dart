import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../commons.dart';
import '../../../../features/cart_checkout/mocks.dart';

void main() {
  late CartBloc cartBloc;
  final mockProduct = dummyProducts.first;
  const mockCart = mockCartModel;

  setUp(() {
    cartBloc = MockCartBloc();
    when(() => cartBloc.state).thenAnswer((_) => const CartInitial());
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
      'should show variant list '
      'when card action is tapped '
      'and [product] has multiple variants', (WidgetTester tester) async {
    /// arrange
    expect(mockProduct.hasMultipleVariants, true);
    await tester.pumpProductAction(mockProduct, cartBloc);

    /// act
    expect(find.byType(ProductVariantsList), findsNothing);
    await tester.tap(find.byType(CardProductAction));
    await tester.pumpAndSettle();

    /// assert
    expect(find.byType(ProductVariantsList), findsOneWidget);
  });

  group('[ProductAction]', () {
    testWidgets(
        'should disable [ProductAction] '
        'when [product] has multiple variants', (WidgetTester tester) async {
      /// arrange
      expect(mockProduct.hasMultipleVariants, true);
      await tester.pumpProductAction(mockProduct, cartBloc);

      /// assert
      final productAction =
          tester.widget<ProductAction>(find.byType(ProductAction));
      expect(productAction.isEnabled, false);
    });

    testWidgets(
        'should enable [ProductAction] '
        'when [product] has single variant', (WidgetTester tester) async {
      /// arrange
      final product =
          mockProduct.copyWith(variants: [mockProduct.variants.first]);
      expect(product.hasMultipleVariants, false);
      await tester.pumpProductAction(product, cartBloc);

      /// assert
      final productAction =
          tester.widget<ProductAction>(find.byType(ProductAction));
      expect(productAction.isEnabled, true);
    });
  });

  testWidgets(
      'should display [product] cart count in [QuantityChanger] '
      'and update it '
      'when cart value is changed', (WidgetTester tester) async {
    /// arrange
    const qty = 2;
    when(() => cartBloc.state).thenAnswer(
      (invocation) => CartLoaded.success(
        mockCart.copyWith(
          items: [
            CartItemModel(variant: mockProduct.variants.first, quantity: qty)
          ],
        ),
      ),
    );

    await tester.pumpProductAction(mockProduct, cartBloc);

    /// assert
    final qtyChanger = tester.widget<QtyChanger>(find.byType(QtyChanger));
    expect(qtyChanger.value, qty);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductAction(
    ProductModel product,
    CartBloc bloc, {
    int productQuantity = 0,
  }) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => bloc,
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              height: 30,
              child: CardProductAction(
                product: product,
                scaleFactor: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
