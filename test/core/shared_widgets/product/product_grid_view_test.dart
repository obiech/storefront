import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

import '../../../../test_commons/fixtures/product/product_models.dart'
    as fixtures;

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductGridView() async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductGridView(
            productModelList: fixtures.fakeCategoryProductList,
            columns: 2,
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Should display a grid of [ProductItemCard]',
      (WidgetTester tester) async {
    await tester.pumpProductGridView();

    expect(find.byType(GridView), findsOneWidget);
    expect(
      find.byType(ProductItemCard, skipOffstage: false),
      findsNWidgets(fixtures.fakeCategoryProductList.length),
    );
  });
}
