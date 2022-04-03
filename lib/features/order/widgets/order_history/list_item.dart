part of 'list.dart';

/// Widget for itemBuilder in [OrderHistoryList]
///
/// Is a card-shaped Container that displays information of an [OrderModel]
/// such as:
/// - Current order status
/// - Order thumbnail
/// - Order products summary
/// - Amount paid
class OrderHistoryListItem extends StatelessWidget {
  const OrderHistoryListItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final cardPadding = context.res.dimens.spacingMiddle;
    final topMargin = context.res.dimens.spacingMedium;

    final boxShadow = BoxShadow(
      color: const Color(0xFF000000)
          .withAlpha((13 / 100 * 255).ceil()), //13% opacity
      blurRadius: 13,
      offset: const Offset(0, 3),
    );

    return Container(
      padding: EdgeInsets.only(
        left: cardPadding,
        right: cardPadding,
        top: topMargin, // to account for Text line height
        bottom: cardPadding,
      ),
      decoration: BoxDecoration(
        color: context.res.colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [boxShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              //TODO: add information based on order status e.g. time left
              // before payment expiry
              const Spacer(),
              OrderStatusChip(orderStatus: order.status),
            ],
          ),
          const _Divider(),
          Row(
            children: [
              _ProductImage(
                thumbnail: order.productsBought[0].product.thumbnailUrl,
              ),
              SizedBox(width: context.res.dimens.spacingMiddle),
              Expanded(
                child: OrderSummarySection(
                  onTap: _navigateToOrderDetails,
                  order: order,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToOrderDetails() {
    //TODO (leovinsen): Implement navigation to Order Details page
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.res.colors.dividerColor,
      height: 1,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    Key? key,
    required this.thumbnail,
  }) : super(key: key);

  final String thumbnail;

  @override
  Widget build(BuildContext context) {
    // TODO (leovinsen): add loading animation
    // TODO (leovinsen): add fallback when image fails to load
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        width: 60,
        height: 60,
        imageUrl: thumbnail,
      ),
    );
  }
}
