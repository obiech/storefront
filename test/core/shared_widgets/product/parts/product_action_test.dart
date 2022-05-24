import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../../test_commons/fixtures/product/product_models.dart';
import '../../../../features/cart_checkout/mocks.dart';

void main() {
  late CartBloc bloc;

  const variant = VariantModel(
    variantId: 'variant',
    name: 'Variant Name',
    imagesUrls: [],
    defaultImageUrl: 'image',
    price: '20000',
    sku: 'sku',
    stock: 5,
    unit: 'unit',
  );

  final cartModel = mockCartModel.copyWith(
    items: [
      const CartItemModel(
        variant: variant,
        quantity: 3,
      )
    ],
  );

  setUp(() {
    bloc = MockCartBloc();
  });

  tearDown(() {
    bloc.close();
  });

  final product = seledaRomaine.copyWith(variants: [variant]);

  final addToCartFinder = find.byKey(ValueKey('${product.id}_add_to_cart'));
  final quantityChangerFinder =
      find.byKey(ValueKey('${product.id}_qty_changer'));

  final incrementButtonFinder = find.byIcon(DropezyIcons.plus);
  final decrementButtonFinder = find.byIcon(DropezyIcons.minus);

  group('Product with single variant', () {
    testWidgets(
        'show add to cart button '
        'when quantity is zero', (WidgetTester tester) async {
      await tester.pumpProductAction(product, bloc);
      expect(addToCartFinder, findsOneWidget);
      expect(quantityChangerFinder, findsNothing);
    });

    testWidgets(
        'show Quantity Changer '
        'when quantity is greater than zero', (WidgetTester tester) async {
      await tester.pumpProductAction(product, bloc, productQuantity: 2);
      expect(addToCartFinder, findsNothing);
      expect(quantityChangerFinder, findsOneWidget);
    });

    testWidgets(
        'show decremented value '
        'when decrement button is tapped', (WidgetTester tester) async {
      final quantity = cartModel.items.first.quantity;

      when(() => bloc.state).thenReturn(CartLoaded.success(cartModel));

      await tester.pumpProductAction(
        product.copyWith(variants: [variant]),
        bloc,
        productQuantity: cartModel.items.first.quantity,
      );
      await tester.pumpAndSettle();
      expect(find.text(quantity.toString()), findsOneWidget);

      await tester.tap(decrementButtonFinder);
      await tester.pumpAndSettle();

      final newQuantity = quantity - 1;
      expect(find.text(newQuantity.toString()), findsOneWidget);

      verify(
        () => bloc.add(EditCartItem(variant, newQuantity)),
      ).called(1);
    });

    testWidgets(
        'show incremented value '
        'when incremented button is tapped', (WidgetTester tester) async {
      final quantity = cartModel.items.first.quantity;

      when(() => bloc.state).thenReturn(CartLoaded.success(cartModel));

      await tester.pumpProductAction(
        product.copyWith(variants: [variant]),
        bloc,
        productQuantity: cartModel.items.first.quantity,
      );
      await tester.pumpAndSettle();
      expect(find.text(quantity.toString()), findsOneWidget);

      await tester.tap(incrementButtonFinder);
      await tester.pumpAndSettle();

      final newQuantity = quantity + 1;
      expect(find.text(newQuantity.toString()), findsOneWidget);

      verify(
        () => bloc.add(EditCartItem(variant, newQuantity)),
      ).called(1);
    });

    testWidgets(
        'show add to cart button '
        'when quantity is decremented to zero', (WidgetTester tester) async {
      final cartModelWithOneItem = cartModel.copyWith(
        items: [
          const CartItemModel(
            variant: variant,
            quantity: 1,
          )
        ],
      );
      when(() => bloc.state)
          .thenReturn(CartLoaded.success(cartModelWithOneItem));

      final quantity = cartModelWithOneItem.items.first.quantity;

      await tester.pumpProductAction(
        product.copyWith(variants: [variant]),
        bloc,
        productQuantity: cartModelWithOneItem.items.first.quantity,
      );
      await tester.pumpAndSettle();

      expect(find.text(quantity.toString()), findsOneWidget);

      await tester.tap(decrementButtonFinder);
      await tester.pumpAndSettle();

      expect(addToCartFinder, findsOneWidget);
      expect(quantityChangerFinder, findsNothing);

      verify(
        () => bloc.add(const EditCartItem(variant, 0)),
      ).called(1);
    });
  });

  group('Product with multiple variants', () {
    testWidgets(
        'should open variant list bottom sheet '
        'when add to cart is tapped', (WidgetTester tester) async {
      /// arrange
      when(() => bloc.state).thenReturn(CartLoaded.success(cartModel));

      await tester.pumpProductAction(
        product.copyWith(
          variants: List.generate(2, (index) => product.variants.first),
        ),
        bloc,
      );
      expect(addToCartFinder, findsOneWidget);
      expect(quantityChangerFinder, findsNothing);

      /// act
      await tester.tap(addToCartFinder);
      await tester.pumpAndSettle();

      /// assert
      expect(find.byType(ProductVariantsList), findsOneWidget);
    });
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductAction(
    BaseProduct product,
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
              child: ProductAction(
                product: product,
                productQuantity: productQuantity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
