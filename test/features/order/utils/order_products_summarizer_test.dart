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
          final products = [
            OrderProductModel(
              product: productSeladaRomaine,
              quantity: 3,
              total: (int.parse(productSeladaRomaine.price) * 3).toString(),
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
          final products = [
            OrderProductModel(
              product: productSeladaRomaine,
              quantity: 3,
              total: (int.parse(productSeladaRomaine.price) * 3).toString(),
            ),
            OrderProductModel(
              product: productBellPepperYellow,
              quantity: 1,
              total: (int.parse(productBellPepperYellow.price) * 1).toString(),
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
          final products = [
            OrderProductModel(
              product: productSeladaRomaine,
              quantity: 3,
              total: (int.parse(productSeladaRomaine.price) * 3).toString(),
            ),
            OrderProductModel(
              product: productBellPepperYellow,
              quantity: 1,
              total: (int.parse(productBellPepperYellow.price) * 1).toString(),
            ),
            OrderProductModel(
              product: productSeladaRomaine,
              quantity: 3,
              total: (int.parse(productSeladaRomaine.price) * 3).toString(),
            ),
            OrderProductModel(
              product: productBellPepperYellow,
              quantity: 1,
              total: (int.parse(productBellPepperYellow.price) * 1).toString(),
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
