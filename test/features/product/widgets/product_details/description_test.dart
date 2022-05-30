import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../../test_commons/fixtures/product/product_models.dart';

void main() {
  late ProductModel mockProduct;

  setUpAll(() {
    mockProduct = pomegranate;
  });

  testWidgets('show full product description', (tester) async {
    await tester.pumpProductDetailSubHeader(mockProduct);

    expect(find.text(mockProduct.description), findsOneWidget);
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
              return ProductDescription(
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
