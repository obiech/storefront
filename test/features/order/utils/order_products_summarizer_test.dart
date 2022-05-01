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
              productId: productSeladaRomaine.productId,
              productName: productSeladaRomaine.name,
              thumbnailUrl: productSeladaRomaine.thumbnailUrl,
              price: productSeladaRomaine.price,
              finalPrice: productSeladaRomaine.price,
              quantity: 3,
              grandTotal:
                  (int.parse(productSeladaRomaine.price) * 3).toString(),
            ),
          ];

          final summary = summarizeOrderProducts(products, 'lainnya');

          expect(summary, products[0].productName);
        },
      );

      test(
        "should return first and second product's name "
        "if there's are two products",
        () {
          final products = [
            OrderProductModel(
              productId: productSeladaRomaine.productId,
              productName: productSeladaRomaine.name,
              thumbnailUrl: productSeladaRomaine.thumbnailUrl,
              price: productSeladaRomaine.price,
              finalPrice: productSeladaRomaine.price,
              quantity: 3,
              grandTotal:
                  (int.parse(productSeladaRomaine.price) * 3).toString(),
            ),
            OrderProductModel(
              productId: productBellPepperYellow.productId,
              productName: productBellPepperYellow.name,
              thumbnailUrl: productBellPepperYellow.thumbnailUrl,
              price: productBellPepperYellow.price,
              finalPrice: productBellPepperYellow.price,
              quantity: 1,
              grandTotal:
                  (int.parse(productBellPepperYellow.price) * 1).toString(),
            ),
          ];

          final summary = summarizeOrderProducts(products, 'lainnya');

          final firstName = products[0].productName;
          final secondName = products[1].productName;

          expect(summary, '$firstName, $secondName');
        },
      );

      test(
        "should return first and second product's name and number of remaining "
        "products if there's are three or more products",
        () {
          final products = [
            OrderProductModel(
              productId: productSeladaRomaine.productId,
              productName: productSeladaRomaine.name,
              thumbnailUrl: productSeladaRomaine.thumbnailUrl,
              price: productSeladaRomaine.price,
              finalPrice: productSeladaRomaine.price,
              quantity: 3,
              grandTotal:
                  (int.parse(productSeladaRomaine.price) * 3).toString(),
            ),
            OrderProductModel(
              productId: productBellPepperYellow.productId,
              productName: productBellPepperYellow.name,
              thumbnailUrl: productBellPepperYellow.thumbnailUrl,
              price: productBellPepperYellow.price,
              finalPrice: productBellPepperYellow.price,
              quantity: 1,
              grandTotal:
                  (int.parse(productBellPepperYellow.price) * 1).toString(),
            ),
            OrderProductModel(
              productId: productSeladaRomaine.productId,
              productName: productSeladaRomaine.name,
              thumbnailUrl: productSeladaRomaine.thumbnailUrl,
              price: productSeladaRomaine.price,
              finalPrice: productSeladaRomaine.price,
              quantity: 3,
              grandTotal:
                  (int.parse(productSeladaRomaine.price) * 3).toString(),
            ),
            OrderProductModel(
              productId: productBellPepperYellow.productId,
              productName: productBellPepperYellow.name,
              thumbnailUrl: productBellPepperYellow.thumbnailUrl,
              price: productBellPepperYellow.price,
              finalPrice: productBellPepperYellow.price,
              quantity: 1,
              grandTotal:
                  (int.parse(productBellPepperYellow.price) * 1).toString(),
            ),
          ];

          final summary = summarizeOrderProducts(products, 'lainnya');

          final firstName = products[0].productName;
          final secondName = products[1].productName;

          expect(summary, '$firstName, $secondName, +2 lainnya');
        },
      );
    },
  );
}
