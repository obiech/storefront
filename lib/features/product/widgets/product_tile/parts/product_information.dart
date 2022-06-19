part of '../product_tile.dart';

/// Responsible for displaying product variant information
class ProductInformation extends StatelessWidget {
  @visibleForTesting
  const ProductInformation({
    Key? key,
    required this.variant,
  }) : super(key: key);

  final VariantModel variant;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          variant.priceAfterDiscount.toCurrency(),
          style: context.res.styles.productTileProductName,
        ),
        const SizedBox(height: 4),
        if (variant.discount != null)
          Row(
            children: [
              Text(
                variant.price.toCurrency(),
                style: context.res.styles.productTileSlashedPrice,
              ),
              const SizedBox(width: 8),
              // TODO: Replace with discount from backend when available
              DiscountTag(
                discountPercentage: (int.parse(variant.discount!) /
                        int.parse(variant.price) *
                        100)
                    .ceil(),
              ),
            ],
          ),
        const SizedBox(height: 4),
        Text(
          variant.name,
          style: context.res.styles.caption2,
        ),
        Row(
          children: [
            Text(
              variant.unit,
              style: context.res.styles.caption3.copyWith(
                color: const Color(0xFF70717D),
              ),
            ),
            if (variant.isAlmostDepleted) ...[
              const SizedBox(width: 8),
              ProductBadge.stockWarning(
                context.res,
                variant.stock,
              ),
            ]
          ],
        ),
      ],
    );
  }
}
