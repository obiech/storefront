part of '../product_item_card.dart';

class ProductCardUtils {
  static void launchVariantBottomSheet(
    BuildContext context,
    ProductModel product,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return ProductVariantsList(product: product);
      },
    );
  }
}
