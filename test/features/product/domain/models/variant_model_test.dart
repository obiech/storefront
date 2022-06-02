import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/product/index.dart';

void main() {
  const variant = VariantModel(
    variantId: '0-variant-id',
    name: '250ml / Pcs',
    defaultImageUrl: 'https://i.imgur.com/rHfndKT.jpeg',
    imagesUrls: [
      'https://i.imgur.com/rHfndKT.jpeg',
    ],
    price: '3200',
    sku: 'SKUTBS002',
    stock: 2,
    unit: '250ml / Pcs',
  );

  group('[hasDiscount] getter', () {
    test(
        'should return false '
        'when discount is null', () async {
      expect(variant.hasDiscount, false);
    });

    test(
        'should return false '
        'when discount is equivalent to zero', () async {
      expect(variant.copyWith(discount: '0000').hasDiscount, false);
    });

    test(
        'should return true '
        'when discount is not null and greater than zero', () async {
      expect(variant.copyWith(discount: '300').hasDiscount, true);
    });
  });
}
