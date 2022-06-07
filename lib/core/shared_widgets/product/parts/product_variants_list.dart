part of '../product_item_card.dart';

/// Display list of [ProductModel] variants with
///
/// * Variant status display e.g out of stock
/// * Option to add to cart
/// * Increment and decrement
class ProductVariantsList extends StatelessWidget {
  /// The product whose variants are to be displayed
  final ProductModel product;

  const ProductVariantsList({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyDismissable(
      child: DraggableScrollableSheet(
        maxChildSize: context.childSize(product.variants.length),
        initialChildSize: context.childSize(product.variants.length),
        builder: (_, controller) {
          return Container(
            decoration: res.styles.bottomSheetStyle,
            child: ClipRRect(
              borderRadius: res.styles.topBorderRadius,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: res.dimens.spacingLarge,
                          horizontal: res.dimens.spacingLarge,
                        ),
                        margin: const EdgeInsets.only(top: 15),
                        child: Text(
                          product.name,
                          style: res.styles.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Expanded(
                        child: VariantsListView(
                          product: product,
                          controller: controller,
                        ),
                      ),
                      const CartSummary(
                        hideWhenEmpty: false,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                  const Positioned(
                    top: 8,
                    child: DragHandle(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

extension BottomSheetSizeX on BuildContext {
  /// Get and fix initialChildSize & maxChildSize for bottom sheet
  double childSize(int itemsCount) {
    final itemsPadding = 10 * (itemsCount - 1);
    const cartSummaryHeight = 42;

    final approxItemsHeight = 85.0 * itemsCount +
        itemsPadding +
        cartSummaryHeight +
        MediaQuery.of(this).padding.bottom;

    final height = MediaQuery.of(this).size.height;

    final error =
        MediaQuery.of(this).orientation == Orientation.landscape ? 0.125 : 0.07;

    final ratio = (approxItemsHeight / height) + error;

    return min(1, ratio);
  }
}
