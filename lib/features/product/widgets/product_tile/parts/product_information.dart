part of '../product_tile.dart';

/// Responsible for displaying product variant information
class ProductInformation extends StatelessWidget {
  @visibleForTesting
  const ProductInformation({
    Key? key,
    required this.product,
  }) : super(key: key);

  final BaseProduct product;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.priceAfterDiscount.toCurrency(),
          style: context.res.styles.productTileProductName,
        ),
        const SizedBox(height: 4),
        if (product.discount != null)
          Row(
            children: [
              Text(
                product.price.toCurrency(),
                style: context.res.styles.productTileSlashedPrice,
              ),
              const SizedBox(width: 8),
              // TODO: Replace with discount from backend when available
              DiscountTag(
                discountPercentage: (int.parse(product.discount!) /
                        int.parse(product.price) *
                        100)
                    .ceil(),
              ),
            ],
          ),
        Text(
          product.name,
          style: context.res.styles.caption2,
        ),
        Row(
          children: [
            Text(
              // TODO: Replace with UoM when property is added
              'Unit of Measurement',
              style: context.res.styles.caption3.copyWith(
                color: const Color(0xFF70717D),
              ),
            ),
            if (product.isAlmostDepleted) ...[
              const SizedBox(width: 8),
              ProductBadge.stockWarning(
                context.res,
                product.stock,
              ),
            ]
          ],
        ),
      ],
    );
  }
}
