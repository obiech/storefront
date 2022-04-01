import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// Displays a single row of the order summary
///
/// This includes an icon for the summary, a title(leading)
/// and a value/result (trailing)
class OrderSummaryItem extends StatelessWidget {
  /// Order summary icon
  ///
  /// Used widget because it may vary from order to order
  final Widget icon;

  /// The order title e.g Saved
  final String leading;

  /// The order result e.g Rp 800,00
  final String trailing;

  const OrderSummaryItem({
    Key? key,
    required this.icon,
    required this.leading,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Row(
      children: [
        icon,
        SizedBox(
          width: res.dimens.spacingMiddle,
        ),
        Expanded(
          child: Text(
            leading,
            style: res.styles.caption1.copyWith(
              fontWeight: FontWeight.w500,
              color: res.colors.grey6,
            ),
          ),
        ),
        Text(
          trailing,
          style: res.styles.caption1.copyWith(
            fontWeight: FontWeight.w600,
            color: res.colors.green,
          ),
        )
      ],
    );
  }
}
