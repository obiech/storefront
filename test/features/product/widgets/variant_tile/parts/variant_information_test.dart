import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../../commons.dart';
import '../../../finders.dart';

void main() {
  const variant = VariantModel(
    productId: 'product-id',
    variantId: '0-variant-id',
    name: '250ml / Pcs',
    defaultImageUrl: 'https://i.imgur.com/rHfndKT.jpeg',
    imagesUrls: [
      'https://i.imgur.com/rHfndKT.jpeg',
    ],
    price: '3200',
    discount: '500',
    sku: 'SKUTBS002',
    stock: 2,
    unit: '250ml / Pcs',
  );

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets('should display variant name', (WidgetTester tester) async {
    /// arrange
    await tester.pumpVariantInformation(variant);

    /// assert
    expect(find.text(variant.name), findsOneWidget);
    expect(ProductPageFinders.variantTileName, findsOneWidget);
  });

  testWidgets('should display variant price', (WidgetTester tester) async {
    /// arrange
    await tester.pumpVariantInformation(variant);

    /// assert
    expect(ProductPageFinders.variantTilePrice, findsOneWidget);
  });

  group('discount', () {
    testWidgets('should display discount details when variant is discounted',
        (WidgetTester tester) async {
      /// arrange
      await tester.pumpVariantInformation(variant);

      /// assert
      expect(ProductPageFinders.variantTileDiscount, findsOneWidget);
      expect(find.byType(DiscountTag), findsOneWidget);
    });

    testWidgets(
        'should not display discount details when variant is not discounted',
        (WidgetTester tester) async {
      /// arrange
      await tester.pumpVariantInformation(variant.copyWith(discount: '000'));

      /// assert
      expect(ProductPageFinders.variantTileDiscount, findsNothing);
      expect(find.byType(DiscountTag), findsNothing);
    });
  });

  group('stock depletion warning', () {
    testWidgets('should display stock warning when variant is almost depleted',
        (WidgetTester tester) async {
      /// arrange
      final context = await tester.pumpVariantInformation(variant);

      /// assert
      expect(find.byType(ProductBadge), findsOneWidget);
      expect(
        find.text(context.res.strings.stockLeft(variant.stock)),
        findsOneWidget,
      );
    });

    testWidgets(
        "should not display stock warning when variant isn't almost depleted",
        (WidgetTester tester) async {
      /// arrange
      final context =
          await tester.pumpVariantInformation(variant.copyWith(stock: 15));

      /// assert
      expect(find.byType(ProductBadge), findsNothing);
      expect(
        find.text(context.res.strings.stockLeft(variant.stock)),
        findsNothing,
      );
    });
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpVariantInformation(
    VariantModel variant,
  ) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: VariantInformation(
                variant: variant,
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
