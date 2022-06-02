import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/product/index.dart';

class ProductPageFinders {
  static Finder variantTileName = find.byKey(VariantTileKeys.variantNameKey);
  static Finder variantTilePrice = find.byKey(VariantTileKeys.variantPriceKey);
  static Finder variantTileDiscount =
      find.byKey(VariantTileKeys.variantDiscountKey);
  static Finder variantTileDiscountTag =
      find.byKey(VariantTileKeys.variantDiscountTagKey);
}
