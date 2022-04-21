import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/domain/domain.dart';

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
  const product = ProductModel(
    productId: 'selada-romaine-id',
    sku: 'selada-romaine-sku',
    name: 'Selada Romaine',
    price: '15000',
    discount: '20000',
    stock: 100,
    thumbnailUrl:
        'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
  );

  final addToCartFinder =
      find.byKey(ValueKey('${product.productId}_add_to_cart'));
  final qtyChangerFinder =
      find.byKey(ValueKey('${product.productId}_qty_changer'));

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
}
