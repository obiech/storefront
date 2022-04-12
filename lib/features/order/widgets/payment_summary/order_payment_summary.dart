import 'package:flutter/material.dart';
import 'package:storefront_app/core/shared_widgets/savings_ribbon.dart';

import '../../../../core/utils/_exporter.dart';

part 'parts/row.dart';

/// A widget for displaying a summary of order payment,
/// from top to bottom:
///
/// - Payment method used (optional)
/// - Total amount saved (optional)
/// - Subtotal
/// - Delivery Fee (optional)
/// - Discount  (optional)
/// - Voucher  (optional)
/// - Dropezy Points (optional)
/// - Amount to be paid
class OrderPaymentSummary extends StatelessWidget {
  const OrderPaymentSummary({
    Key? key,
    this.paymentMethod,
    this.totalSavings,
    required this.subtotal,
    required this.deliveryFee,
    this.isFreeDelivery = false,
    this.deliveryFeeAfterDiscount,
    this.discountFromItems,
    this.discountFromVoucher,
    this.dropezyPointsUsed,
    required this.grandTotal,
  })  : assert(deliveryFeeAfterDiscount == null || !isFreeDelivery),
        super(key: key);

  /// Name of payment method used
  final String? paymentMethod;

  /// Total amount saved by user in this transaction
  final String? totalSavings;

  /// Subtotal (before any discounts and extra fees)
  final String subtotal;

  /// Delivery Fee
  final String deliveryFee;

  /// Delivery Fee after discount is applied.
  /// Will apply a strikethrough effect if this is not [null].
  final String? deliveryFeeAfterDiscount;

  /// Whether or not delivery fee is free
  /// Will apply a strikethrough effect if this [true].
  final bool isFreeDelivery;

  /// Total discount from items (e.g. an item is on sale)
  final String? discountFromItems;

  /// Total discount earned from using voucher
  final String? discountFromVoucher;

  /// Total discount earned from using Dropezy Points
  final String? dropezyPointsUsed;

  /// Total amount to be paid
  final String grandTotal;

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (paymentMethod != null) ...[
          Padding(
            padding: EdgeInsets.only(
              top: res.dimens.pagePadding,
              left: res.dimens.pagePadding,
              right: res.dimens.pagePadding,
              bottom: res.dimens.spacingMiddle,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.res.strings.paymentDetails,
                  style: context.res.styles.subtitle,
                ),
                SizedBox(height: res.dimens.spacingMiddle),
                _PaymentMethodRow(paymentMethod: paymentMethod!),
              ],
            ),
          ),
        ],
        if (totalSavings != null)
          SavingsRibbon(
            totalSavings: totalSavings!,
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: res.dimens.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: res.dimens.spacingLarge),
              _SummaryItemRow(
                isDiscount: false,
                label: res.strings.subtotal,
                value: subtotal,
              ),
              SizedBox(height: res.dimens.spacingMedium),
              _DeliveryFeeRow(
                deliveryFee: deliveryFee,
                deliveryFeeAfterDiscount: deliveryFeeAfterDiscount,
                isFreeDelivery: isFreeDelivery,
              ),
              if (discountFromItems != null) ...[
                SizedBox(height: res.dimens.spacingMedium),
                _SummaryItemRow(
                  isDiscount: true,
                  label: res.strings.discount,
                  value: discountFromItems!,
                ),
              ],
              if (discountFromVoucher != null) ...[
                SizedBox(height: res.dimens.spacingMedium),
                _SummaryItemRow(
                  isDiscount: true,
                  label: res.strings.voucher,
                  value: discountFromVoucher!,
                ),
              ],
              if (dropezyPointsUsed != null) ...[
                SizedBox(height: res.dimens.spacingMedium),
                _SummaryItemRow(
                  isDiscount: true,
                  label: res.strings.dropezyPoints,
                  value: dropezyPointsUsed!,
                ),
              ],
              SizedBox(height: res.dimens.spacingMedium),
              _AmountToBePaidRow(grandTotal: grandTotal),
              SizedBox(height: res.dimens.pagePadding),
            ],
          ),
        )
      ],
    );
  }
}
