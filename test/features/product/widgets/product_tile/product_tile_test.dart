import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

void main() {
  /// Base model for test has to have a null discount
  /// because it affects the outcome
  const mockVariant = VariantModel(
    variantId: 'selada-romaine-id',
    sku: 'selada-romaine-sku',
    name: 'Selada Romaine',
    price: '15000',
    stock: 100,
    unit: '250g',
    defaultImageUrl: 'image-url-1',
    imagesUrls: ['image-url-1', 'image-url-2'],
  );

  group(
    '[ProductTile]',
    () {
      testWidgets(
        'should display only necessary product information',
        (tester) async {
          const product = mockVariant;
          await tester.pumpProductTile(variant: product);

          tester.assertCommonWidgets(product);

          expect(find.byType(DiscountTag), findsNothing);
          expect(find.byType(ProductBadge), findsNothing);
        },
      );

      testWidgets(
        'Should display discount information if available',
        (tester) async {
          final product = mockVariant.copyWith(discount: '100000');
          await tester.pumpProductTile(variant: product);

          tester.assertCommonWidgets(product);

          expect(find.byType(DiscountTag), findsOneWidget);
          expect(find.text(product.price.toCurrency()), findsOneWidget);
          expect(find.byType(ProductBadge), findsNothing);
        },
      );

      testWidgets(
        'Should display stock warning if stock is low',
        (tester) async {
          final product = mockVariant.copyWith(stock: 1);
          await tester.pumpProductTile(variant: product);

          tester.assertCommonWidgets(product);

          expect(find.byType(DiscountTag), findsNothing);
          expect(product.isAlmostDepleted, true);
          expect(find.byType(ProductBadge), findsOneWidget);
        },
      );

      testWidgets(
        'should display Widget that is passed in [trailing]',
        (tester) async {
          const product = mockVariant;
          const trailing = Icon(Icons.plus_one);
          await tester.pumpProductTile(
            variant: product,
            trailing: trailing,
          );

          tester.assertCommonWidgets(product);
          expect(find.byWidget(trailing), findsOneWidget);
        },
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpProductTile({
    required VariantModel variant,
    Widget? trailing,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              ctx = context;
              return ProductTile(
                variant: variant,
                trailing: trailing,
              );
            },
          ),
        ),
      ),
    );

    return ctx;
  }

  /// Assert that product image, name and price
  /// are always present
  void assertCommonWidgets(VariantModel variant) {
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CachedNetworkImage &&
            widget.imageUrl == variant.thumbnailUrl,
      ),
      findsOneWidget,
    );
    expect(find.text(variant.name), findsOneWidget);
    expect(
      find.text(variant.priceAfterDiscount.toCurrency()),
      findsOneWidget,
    );

    expect(find.text(variant.unit), findsOneWidget);
  }
}
