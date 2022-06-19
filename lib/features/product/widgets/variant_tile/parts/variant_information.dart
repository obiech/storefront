part of '../variant_tile.dart';

/// Responsible for displaying product variant information
class VariantInformation extends StatelessWidget {
  @visibleForTesting
  const VariantInformation({
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
          variant.name,
          key: VariantTileKeys.variantNameKey,
          style: context.res.styles.caption1,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          variant.priceAfterDiscount.toCurrency(),
          key: VariantTileKeys.variantPriceKey,
          style: context.res.styles.caption1
              .copyWith(fontWeight: FontWeight.w600)
              .withLineHeight(17),
        ),
        if (variant.hasDiscount) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                variant.price.toCurrency(),
                key: VariantTileKeys.variantDiscountKey,
                style: context.res.styles.productTileSlashedPrice,
              ),
              const SizedBox(width: 4),
              // TODO: Replace with discount from backend when available
              DiscountTag(
                key: VariantTileKeys.variantDiscountTagKey,
                discountPercentage: (int.parse(variant.discount!) /
                        int.parse(variant.price) *
                        100)
                    .ceil(),
              ),
            ],
          )
        ],
        if (variant.isAlmostDepleted) ...[
          const SizedBox(height: 4),
          ProductBadge.stockWarning(
            context.res,
            variant.stock,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
            textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 8)
                .withLineHeight(9.75),
          ),
        ]
      ],
    );
  }
}
