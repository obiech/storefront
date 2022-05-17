import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/domain/domain.dart';
import 'package:storefront_app/res/strings/english_strings.dart';

import '../../../../test_commons/fixtures/product/product_models.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductItemCard(
    ProductModel productModel, {
    int itemQuantity = 0,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspectRatio(
            aspectRatio: 13 / 25,
            child: ProductItemCard(
              product: productModel,
              itemQuantity: itemQuantity,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  const product = seledaRomaine;

  final addToCartFinder = find.byKey(ValueKey('${product.id}_add_to_cart'));
  final qtyChangerFinder = find.byKey(ValueKey('${product.id}_qty_changer'));

  final incrementButtonFinder = find.byIcon(DropezyIcons.plus);
  final decrementButtonFinder = find.byIcon(DropezyIcons.minus);

  testWidgets('When quantity is zero, show add to cart button',
      (WidgetTester tester) async {
    await tester.pumpProductItemCard(product);
    expect(addToCartFinder, findsOneWidget);
    expect(qtyChangerFinder, findsNothing);
  });

  testWidgets('When quantity is greater than zero, show Quantity Changer',
      (WidgetTester tester) async {
    await tester.pumpProductItemCard(product, itemQuantity: 2);
    expect(addToCartFinder, findsNothing);
    expect(qtyChangerFinder, findsOneWidget);
  });

  testWidgets('When quantity is decremented, value displayed is decremented',
      (WidgetTester tester) async {
    const quantity = 18;
    await tester.pumpProductItemCard(product, itemQuantity: quantity);
    expect(find.text(quantity.toString()), findsOneWidget);

    await tester.tap(decrementButtonFinder);
    await tester.pump();
    expect(find.text((quantity - 1).toString()), findsOneWidget);
  });

  testWidgets('When quantity is incremented, value displayed is incremented',
      (WidgetTester tester) async {
    const quantity = 18;
    await tester.pumpProductItemCard(product, itemQuantity: quantity);
    expect(find.text(quantity.toString()), findsOneWidget);

    await tester.tap(incrementButtonFinder);
    await tester.pump();
    expect(find.text((quantity + 1).toString()), findsOneWidget);
  });

  testWidgets('Quantity Changer & "Add to cart" transition is smooth',
      (WidgetTester tester) async {
    await tester.pumpProductItemCard(product);
    expect(addToCartFinder, findsOneWidget);
    expect(qtyChangerFinder, findsNothing);

    // Increment qty to one
    await tester.tap(addToCartFinder);
    await tester.pumpAndSettle();
    expect(qtyChangerFinder, findsOneWidget);
    expect(addToCartFinder, findsNothing);

    // decrement to zero
    await tester.tap(decrementButtonFinder);
    await tester.pumpAndSettle();
    expect(addToCartFinder, findsOneWidget);
    expect(qtyChangerFinder, findsNothing);
  });

  testWidgets(
      'When a product is out of stock, gray it out '
      'and show out of stock label', (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductItemCard(
      product.copyWith(
        stock: 0,
        status: ProductStatus.OUT_OF_STOCK,
      ),
    );

    expect(find.byType(OutOfStockOverdraw), findsOneWidget);
    final outOfStockFinder = find.text(EnglishStrings().outOfStock);
    expect(outOfStockFinder, findsOneWidget);

    final outOfStockButton = tester.widget<ElevatedButton>(
      find.ancestor(
        of: outOfStockFinder,
        matching: find.byType(ElevatedButton),
      ),
    );

    expect(outOfStockButton.enabled, false);
  });
}
