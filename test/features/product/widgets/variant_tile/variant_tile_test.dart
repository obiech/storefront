import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../commons.dart';

void main() {
  const mockVariant = VariantModel(
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

  testWidgets(
    'should display Widget that is passed in [trailing]',
    (tester) async {
      const variant = mockVariant;
      const trailing = Icon(Icons.plus_one);
      await tester.pumpVariantTile(
        variant,
        trailing: trailing,
      );

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
      await tester.pumpVariantTile(
        variant,
        trailing: trailing,
      );

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
                of: find.byType(VariantInformation),
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
      await tester.pumpVariantTile(
        variant,
        trailing: trailing,
      );

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
                of: find.byType(VariantInformation),
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
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpVariantTile(
    VariantModel variant, {
    Widget? trailing,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VariantTile(
            variant: variant,
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}
