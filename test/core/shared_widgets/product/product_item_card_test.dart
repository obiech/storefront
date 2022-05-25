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
    ProductCallback? onTap,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspectRatio(
            aspectRatio: 13 / 25,
            child: ProductItemCard(
              product: productModel,
              itemQuantity: itemQuantity,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  const product = seledaRomaine;

  testWidgets(
      'show "out of stock" label and gray out card '
      'when a product is out of stock', (WidgetTester tester) async {
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

  testWidgets('should display product name', (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductItemCard(product);

    /// assert
    expect(find.text(product.name.capitalize()), findsOneWidget);
  });

  testWidgets('should display product unit', (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductItemCard(product);

    /// assert
    expect(find.text(product.unit), findsOneWidget);
  });

  testWidgets('should display product price', (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductItemCard(product);

    /// assert
    expect(find.text(product.price.toCurrency()), findsOneWidget);
  });

  testWidgets('should fire [ProductCallback] when tapped',
      (WidgetTester tester) async {
    /// arrange
    bool isTapped = false;
    await tester.pumpProductItemCard(
      product,
      onTap: (_) {
        isTapped = true;
      },
    );

    await tester.tap(find.byType(ProductItemCard));

    /// assert
    expect(isTapped, true);
  });

  /// TODO(obella): Test discount display when ready
}
