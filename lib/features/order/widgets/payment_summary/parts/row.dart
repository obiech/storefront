part of '../order_payment_summary.dart';

/// Individual item rows for [OrderPaymentSummary]
class _SummaryItemRow extends StatelessWidget {
  const _SummaryItemRow({
    Key? key,
    required this.isDiscount,
    required this.label,
    required this.value,
  }) : super(key: key);

  final bool isDiscount;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.res.styles.caption2,
        ),
        Row(
          children: [
            Text(
              isDiscount ? '- ${value.toCurrency()}' : value.toCurrency(),
              style: isDiscount
                  ? context.res.styles.caption2.copyWith(
                      color: context.res.colors.green,
                      fontWeight: FontWeight.w500,
                    )
                  : context.res.styles.caption2.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);

  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.res.strings.paymentMethod,
          style: context.res.styles.caption2.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Text(
              paymentMethod,
              style: context.res.styles.caption2.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Item row for Delivery Fee
class _DeliveryFeeRow extends StatelessWidget {
  const _DeliveryFeeRow({
    Key? key,
    required this.deliveryFee,
    this.deliveryFeeAfterDiscount,
    this.isFreeDelivery = false,
  })  : assert(deliveryFeeAfterDiscount == null || !isFreeDelivery),
        super(key: key);

  final String deliveryFee;
  final String? deliveryFeeAfterDiscount;
  final bool isFreeDelivery;

  @override
  Widget build(BuildContext context) {
    Widget? trailingWidget;

    if (deliveryFeeAfterDiscount != null) {
      trailingWidget = Text(
        deliveryFeeAfterDiscount!.toCurrency(),
        style: context.res.styles.caption2.copyWith(
          color: context.res.colors.green,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    if (isFreeDelivery) {
      trailingWidget = Text(
        '${context.res.strings.free}!',
        style: context.res.styles.caption2.copyWith(
          color: context.res.colors.green,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            context.res.strings.deliveryFee,
            style: context.res.styles.caption2,
          ),
        ),
        Text(
          deliveryFee.toCurrency(),
          style: context.res.styles.caption2.copyWith(
            color: trailingWidget != null
                ? context.res.colors.green
                : context.res.colors.black,
            fontWeight: FontWeight.w500,
            decoration:
                trailingWidget != null ? TextDecoration.lineThrough : null,
          ),
        ),
        if (trailingWidget != null) ...[
          SizedBox(width: context.res.dimens.spacingMedium),
          trailingWidget
        ]
      ],
    );
  }
}

/// Row for displaying amount to be paid by customer
class _AmountToBePaidRow extends StatelessWidget {
  const _AmountToBePaidRow({
    Key? key,
    required this.grandTotal,
  }) : super(key: key);

  final String grandTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.res.strings.totalPayment,
          style: context.res.styles.caption1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          grandTotal.toCurrency(),
          style: context.res.styles.caption1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
