part of '../section.dart';

/// List of products purchased by user.
///
/// Contains information such as:
/// - Product thumbnail
/// - Product name
/// - Qty purchased
/// - Product unit price
/// - Product total price
class ProductsList extends StatelessWidget {
  const ProductsList({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<OrderProductModel> products;

  @override
  Widget build(BuildContext context) {
    final Resources res = context.res;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];
        final quantity = product.quantity;
        final totalPrice = product.grandTotal;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: context.res.colors.paleBlue,
                child: CachedNetworkImage(
                  height: 50,
                  width: 50,
                  imageUrl: product.thumbnailUrl,
                ),
              ),
            ),
            SizedBox(width: res.dimens.spacingMiddle),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.productName,
                    style: res.styles.caption2.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.7, // 12 * 1.7 = 20dp
                    ),
                  ),
                  Text(
                    '$quantity x ${product.price.toCurrency()}',
                    style: res.styles.caption2.copyWith(
                      height: 1.5, // 12 * 1.5 = 18dp
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: res.dimens.spacingSmlarge),
            Text(
              totalPrice.toCurrency(),
              style: res.styles.caption2.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.7, // 12 * 1.7 = 20dp
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => SizedBox(
        height: res.dimens.spacingSmlarge,
      ),
    );
  }
}
