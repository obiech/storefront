part of '../list.dart';

/// Order Summary Section located to the right of Order thumbnail consisting of:
/// - Order summary (products bought, amount spent)
/// - An icon Chevron Right which 'notifies' user this is clickable
///
/// [onTap] will be called when the whole summary section is called, not just
/// when button is tapped.
class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OrderSummary(
            orderProducts: order.productsBought,
            amountPaid: order.total,
          ),
        ),
        SizedBox(width: context.res.dimens.spacingMedium),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            context.res.paths.icChevronRight,
            color: context.res.colors.grey4,
            width: 16,
            height: 12,
          ),
        ),
      ],
    );
  }
}

/// Consists of select few product names and amount paid by customer.
class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    Key? key,
    required this.orderProducts,
    required this.amountPaid,
  }) : super(key: key);

  final List<OrderProductModel> orderProducts;
  final String amountPaid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          summarizeOrderProducts(
            orderProducts,
            context.res.strings.otherProducts,
          ),
          style: context.res.styles.caption2.copyWith(
            height: 1.5, // translates to a height of 18dp (12dp x 1.5)
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          context.res.strings.totalSpent,
          style: context.res.styles.caption3.copyWith(
            fontWeight: FontWeight.w500,
            color: context.res.colors.grey6,
          ),
        ),
        Text(
          amountPaid.toCurrency(),
          style: context.res.styles.caption1.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.6, // this translates to a height of 22dp (14dp x 1.6)
          ),
        ),
      ],
    );
  }
}
