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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: res.colors.darkBlue,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: res.dimens.spacingLarge,
                      horizontal: res.dimens.spacingLarge,
                    ),
                    child: Text(
                      product.name,
                      style: res.styles.subtitle.copyWith(
                        color: res.colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final variant = product.variants[index];
                        return ProductTile(
                          variant: variant,
                          trailing: SizedBox(
                            width: 90,
                            height: 40,
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                textScaleFactor: .8,
                              ),
                              child: ProductAction(
                                product: variant,
                              ),
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: product.variants.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CartSummary(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
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

    final approxItemsHeight = 70.0 * itemsCount +
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
