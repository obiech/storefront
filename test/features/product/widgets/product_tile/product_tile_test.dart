import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

void main() {
  /// Base model for test has to have a null discount
  /// because it affects the outcome
  const mockProduct = ProductModel(
    productId: 'selada-romaine-id',
    sku: 'selada-romaine-sku',
    name: 'Selada Romaine',
    price: '15000',
    variants: [],
    defaultProduct: '',
    stock: 100,
    thumbnailUrl: 'some-url',
  );

  group(
    '[ProductTile]',
    () {
      testWidgets(
        'should display only necessary product information',
        (tester) async {
          const product = mockProduct;
          await tester.pumpProductTile(product: product);

          tester.assertCommonWidgets(product);

          expect(find.byType(DiscountTag), findsNothing);
          expect(find.byType(ProductBadge), findsNothing);
        },
      );

      testWidgets(
        'Should display discount information if available',
        (tester) async {
          final product = mockProduct.copyWith(discount: '100000');
          await tester.pumpProductTile(product: product);

          tester.assertCommonWidgets(product);

          expect(find.byType(DiscountTag), findsOneWidget);
          expect(find.byType(ProductBadge), findsNothing);
        },
      );

      testWidgets(
        'Should display stock warning if stock is low',
        (tester) async {
          final product = mockProduct.copyWith(stock: 1);
          await tester.pumpProductTile(product: product);

          tester.assertCommonWidgets(product);

          expect(find.byType(DiscountTag), findsNothing);
          expect(product.isAlmostDepleted, true);
          expect(find.byType(ProductBadge), findsOneWidget);
        },
      );

      testWidgets(
        'should display Widget that is passed in [trailing]',
        (tester) async {
          const product = mockProduct;
          const trailing = Icon(Icons.plus_one);
          await tester.pumpProductTile(
            product: product,
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
    required ProductModel product,
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
                product: product,
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
  void assertCommonWidgets(ProductModel product) {
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CachedNetworkImage &&
            widget.imageUrl == product.thumbnailUrl,
      ),
      findsOneWidget,
    );
    expect(find.text(product.name), findsOneWidget);
    expect(find.text(product.price.toCurrency()), findsOneWidget);

    // TODO: Replace with proper tests once UoM is added into model
    expect(find.text('Unit of Measurement'), findsOneWidget);
  }
}
