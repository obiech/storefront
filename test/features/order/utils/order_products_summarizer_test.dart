import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/domain/domains.dart';
import 'package:storefront_app/features/order/utils/order_products_summarizer.dart';

import '../../../../test_commons/fixtures/product/product_models.dart';

void main() {
  group(
    '[summarizeOrderProducts()]',
    () {
      test(
        "should return first product's name if there's only one product ",
        () {
          const products = [
            OrderProductModel(
              product: productSeladaRomaine,
              quantity: 3,
            ),
          ];

          final summary = summarizeOrderProducts(products, 'lainnya');

          expect(summary, products[0].product.name);
        },
      );

      test(
        "should return first and second product's name "
        "if there's are two products",
        () {
          const products = [
            OrderProductModel(
              product: productSeladaRomaine,
              quantity: 3,
            ),
            OrderProductModel(
              product: productBellPepperYellow,
              quantity: 1,
            ),
          ];

          final summary = summarizeOrderProducts(products, 'lainnya');

          final firstName = products[0].product.name;
          final secondName = products[1].product.name;

          expect(summary, '$firstName, $secondName');
        },
      );

      test(
        "should return first and second product's name and number of remaining "
        "products if there's are three or more products",
        () {
          const products = [
            OrderProductModel(
              product: productSeladaRomaine,
              quantity: 3,
            ),
            OrderProductModel(
              product: productBellPepperYellow,
              quantity: 1,
            ),
            OrderProductModel(
              product: productSeladaRomaine,
              quantity: 3,
            ),
            OrderProductModel(
              product: productBellPepperYellow,
              quantity: 1,
            ),
          ];

          final summary = summarizeOrderProducts(products, 'lainnya');

          final firstName = products[0].product.name;
          final secondName = products[1].product.name;

          expect(summary, '$firstName, $secondName, +2 lainnya');
        },
      );
    },
  );
}
