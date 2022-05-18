import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../test_commons/fixtures/product/product_models.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductAction(
    BaseProduct product, {
    int productQuantity = 0,
  }) async {
    await pumpWidget(
      MaterialApp(
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
    );
  }
}

void main() {
  const product = seledaRomaine;

  final addToCartFinder = find.byKey(ValueKey('${product.id}_add_to_cart'));
  final quantityChangerFinder =
      find.byKey(ValueKey('${product.id}_qty_changer'));

  final incrementButtonFinder = find.byIcon(DropezyIcons.plus);
  final decrementButtonFinder = find.byIcon(DropezyIcons.minus);

  testWidgets(
      'show add to cart button '
      'when quantity is zero', (WidgetTester tester) async {
    await tester.pumpProductAction(product);
    expect(addToCartFinder, findsOneWidget);
    expect(quantityChangerFinder, findsNothing);
  });

  testWidgets(
      'show Quantity Changer '
      'when quantity is greater than zero', (WidgetTester tester) async {
    await tester.pumpProductAction(product, productQuantity: 2);
    expect(addToCartFinder, findsNothing);
    expect(quantityChangerFinder, findsOneWidget);
  });

  testWidgets(
      'show decremented value '
      'when decrement button is tapped', (WidgetTester tester) async {
    const quantity = 18;
    await tester.pumpProductAction(product, productQuantity: quantity);
    expect(find.text(quantity.toString()), findsOneWidget);

    await tester.tap(decrementButtonFinder);
    await tester.pump();
    expect(find.text((quantity - 1).toString()), findsOneWidget);
  });

  testWidgets(
      'show incremented value '
      'when incremented button is tapped', (WidgetTester tester) async {
    const quantity = 18;
    await tester.pumpProductAction(product, productQuantity: quantity);
    expect(find.text(quantity.toString()), findsOneWidget);

    await tester.tap(incrementButtonFinder);
    await tester.pump();
    expect(find.text((quantity + 1).toString()), findsOneWidget);
  });

  testWidgets(
      'show add to cart button '
      'when quantity is decremented to zero', (WidgetTester tester) async {
    await tester.pumpProductAction(product, productQuantity: 1);
    expect(quantityChangerFinder, findsOneWidget);
    expect(addToCartFinder, findsNothing);

    // Decrement qty to zero
    await tester.tap(decrementButtonFinder);
    await tester.pumpAndSettle();
    expect(addToCartFinder, findsOneWidget);
    expect(quantityChangerFinder, findsNothing);
  });
}
