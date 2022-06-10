import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../../test_commons/fixtures/product/product_models.dart';
import '../../../../commons.dart';

void main() {
  late ProductModel mockProduct;

  setUpAll(() {
    mockProduct = pomegranate;
    setUpLocaleInjection();
  });

  testWidgets('show product name in sub-header', (tester) async {
    await tester.pumpProductDetailSubHeader(mockProduct);

    expect(find.text(mockProduct.name), findsOneWidget);
  });

  testWidgets(
      'should show product depletion badge '
      'when product stock is almost depleted', (WidgetTester tester) async {
    /// arrange
    final productModel = mockProduct.copyWith(stock: 2);
    final context = await tester.pumpProductDetailSubHeader(productModel);

    /// assert
    expect(find.byType(ProductBadge), findsOneWidget);

    final badge = tester.firstWidget<ProductBadge>(find.byType(ProductBadge));
    expect(badge.text, context.res.strings.stockLeft(productModel.stock));
  });

  testWidgets('should have a like button', (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductDetailSubHeader(mockProduct);

    /// assert
    expect(
      find.ancestor(
        of: find.byIcon(DropezyIcons.heart_alt),
        matching: find.byType(IconButton),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should have a share button', (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductDetailSubHeader(mockProduct);

    /// assert
    expect(
      find.ancestor(
        of: find.byIcon(DropezyIcons.share),
        matching: find.byType(IconButton),
      ),
      findsOneWidget,
    );
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpProductDetailSubHeader(
    ProductModel productModel,
  ) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              ctx = context;
              return ProductDetailsSubHeader(
                product: productModel,
              );
            },
          ),
        ),
      ),
    );

    return ctx;
  }
}
