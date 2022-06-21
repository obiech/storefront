import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../../test_commons/fixtures/product/variant_models.dart'
    as variant_fixtures;

void main() {
  group(
    '[CartState]',
    () {
      const cartNonEmpty = mockCartModel;
      final cartEmpty = mockCartModel.copyWith(items: []);
      final cartOutOfStock = mockCartModel.copyWith(
        items: [
          CartItemModel(
            variant: variant_fixtures.variantMango.copyWith(stock: 0),
            quantity: 1,
          ),
        ],
      );

      test(
        'should be valid for checkout '
        'when state is [CartLoaded] '
        'and is not calculating summary '
        'and is not empty',
        () {
          final state = CartLoaded.success(cartNonEmpty);
          expect(state.isValidForCheckout, true);
        },
      );

      group(
        'should not be valid for checkout',
        () {
          test(
            'when state is [CartLoaded] '
            'and is calculating summary',
            () {
              final state = CartLoaded.loading(cartNonEmpty);
              expect(state.isValidForCheckout, false);
            },
          );

          test(
            'when state is [CartLoaded] '
            'and is empty',
            () {
              final state = CartLoaded.success(cartEmpty);
              expect(state.isValidForCheckout, false);
            },
          );

          test(
            'when state is [CartLoaded] '
            'and in stock items are empty '
            'but out of stock items are not empty',
            () {
              final state = CartLoaded.success(cartOutOfStock);
              expect(state.isValidForCheckout, false);
            },
          );

          group(
            'when state is not [CartLoaded], for example:',
            () {
              /// aserts that [state] is not valid for checkout
              Future<void> testFn(CartState state) async {
                test(
                  '[${state.runtimeType.toString()}]',
                  () => expect(state.isValidForCheckout, false),
                );
              }

              const states = [CartInitial(), CartLoading(), CartFailedToLoad()];

              states.forEach(testFn);
            },
          );
        },
      );
    },
  );
}
