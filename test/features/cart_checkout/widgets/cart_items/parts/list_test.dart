import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../../test_commons/fixtures/product/variant_models.dart'
    as variant_fixtures;
import '../../../../../commons.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    '[CartItemsList]',
    () {
      final cartItems = [
        CartItemModel(
          variant: variant_fixtures.variantMango.copyWith(stock: 100),
          quantity: 3,
        ),
        CartItemModel(
          variant: variant_fixtures.variantRice.copyWith(stock: 50),
          quantity: 3,
        ),
      ];

      testWidgets(
        'should display a list of [CartItemTile] '
        'and show correct number of items ',
        (tester) async {
          await tester.pumpCartItemsList(items: cartItems);

          expect(find.byType(ListView), findsOneWidget);
          expect(find.byType(CartItemTile), findsNWidgets(cartItems.length));
        },
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCartItemsList({required List<CartItemModel> items}) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartItemsList(items: items),
        ),
      ),
    );
  }
}
