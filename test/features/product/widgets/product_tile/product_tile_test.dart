import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../commons.dart';

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

  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    '[ProductTile]',
    () {
      testWidgets(
        'should display only necessary product information',
        (tester) async {
          const variant = mockVariant;
          await tester.pumpProductTile(variant: variant);

          tester.assertCommonWidgets(variant);

          expect(find.byType(DiscountTag), findsNothing);
          expect(find.byType(ProductBadge), findsNothing);
        },
      );

      testWidgets(
        'Should display discount information if available',
        (tester) async {
          final variant = mockVariant.copyWith(discount: '100000');
          await tester.pumpProductTile(variant: variant);

          tester.assertCommonWidgets(variant);

          expect(find.byType(DiscountTag), findsOneWidget);
          expect(find.text(variant.price.toCurrency()), findsOneWidget);
          expect(find.byType(ProductBadge), findsNothing);
        },
      );

      testWidgets(
        'Should display stock warning if stock is low',
        (tester) async {
          final variant = mockVariant.copyWith(stock: 1);
          await tester.pumpProductTile(variant: variant);

          tester.assertCommonWidgets(variant);

          expect(find.byType(DiscountTag), findsNothing);
          expect(variant.isAlmostDepleted, true);
          expect(find.byType(ProductBadge), findsOneWidget);
        },
      );

      testWidgets(
        'should display Widget that is passed in [trailing]',
        (tester) async {
          const variant = mockVariant;
          const trailing = Icon(Icons.plus_one);
          await tester.pumpProductTile(
            variant: variant,
            trailing: trailing,
          );

          tester.assertCommonWidgets(variant);
          expect(find.byWidget(trailing), findsOneWidget);
        },
      );

      testWidgets(
        'should have 100% opacity '
        'when variant is in stock',
        (tester) async {
          final variant = mockVariant.copyWith(stock: 100);
          const trailing = Icon(Icons.plus_one);
          const expectedOpacity = 1.0;
          await tester.pumpProductTile(
            variant: variant,
            trailing: trailing,
          );

          tester.assertCommonWidgets(variant);

          expect(
            tester
                .widget<Opacity>(
                  find.ancestor(
                    of: find.byType(DropezyImage),
                    matching: find.byType(Opacity),
                  ),
                )
                .opacity,
            expectedOpacity,
          );

          expect(
            tester
                .widget<Opacity>(
                  find.ancestor(
                    of: find.byType(ProductInformation),
                    matching: find.byType(Opacity),
                  ),
                )
                .opacity,
            expectedOpacity,
          );
        },
      );

      testWidgets(
        'should have 50% opacity for variant image and information '
        'and not trailing widget '
        'when variant is out of stock',
        (tester) async {
          final variant = mockVariant.copyWith(stock: 0);
          const trailing = Icon(Icons.plus_one);
          const expectedOpacity = 0.5;
          await tester.pumpProductTile(
            variant: variant,
            trailing: trailing,
          );

          tester.assertCommonWidgets(variant);

          // Image should have 50% opacity
          expect(
            tester
                .widget<Opacity>(
                  find.ancestor(
                    of: find.byType(DropezyImage),
                    matching: find.byType(Opacity),
                  ),
                )
                .opacity,
            expectedOpacity,
          );

          // Product Information should have 50% opacity
          expect(
            tester
                .widget<Opacity>(
                  find.ancestor(
                    of: find.byType(ProductInformation),
                    matching: find.byType(Opacity),
                  ),
                )
                .opacity,
            expectedOpacity,
          );

          // Trailing should be displayed but not be affected
          final finderTrailing = find.byWidget(trailing);
          expect(finderTrailing, findsOneWidget);
          expect(
            find.ancestor(
              of: finderTrailing,
              matching: find.byType(Opacity),
            ),
            findsNothing,
          );
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
