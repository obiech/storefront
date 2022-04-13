import 'package:flutter/material.dart';

import '../../../core/utils/build_context.ext.dart';
import '../domain/models/order_model.dart';

/// Widget for displaying current order status
///
/// Maps [OrderStatus] enums to human-friendly strings and appropriate
/// background [Color]. Design is similar to a [Chip]
///
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({
    Key? key,
    required this.orderStatus,
  }) : super(key: key);

  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    late String label;
    late Color backgroundColor;
    late Color textColor;

    switch (orderStatus) {
      case OrderStatus.awaitingPayment:
        label = context.res.strings.awaitingPayment;
        backgroundColor = context.res.colors.lightOrange;
        textColor = context.res.colors.orange;
        break;
      case OrderStatus.paid:
        label = context.res.strings.inProcess;
        backgroundColor = context.res.colors.paleYellow;
        textColor = context.res.colors.deepYellow;
        break;
      case OrderStatus.inDelivery:
        label = context.res.strings.inDelivery;
        backgroundColor = context.res.colors.paleGreen;
        textColor = context.res.colors.green;
        break;
      case OrderStatus.arrived:
        label = context.res.strings.arrivedAtDestination;
        backgroundColor = context.res.colors.paleBlue;
        textColor = context.res.colors.blue;
        break;
      case OrderStatus.cancelled:
        //TODO (leovinsen): update with proper colors when available
        label = context.res.strings.cancelled;
        backgroundColor = context.res.colors.red;
        textColor = context.res.colors.white;
        break;
      case OrderStatus.failed:
        //TODO (leovinsen): update with proper colors when available
        label = context.res.strings.failed;
        backgroundColor = context.res.colors.red;
        textColor = context.res.colors.white;
        break;
      case OrderStatus.unspecified:
        //TODO (leovinsen): update with proper fallback
        label = context.res.strings.unspecified;
        backgroundColor = context.res.colors.black;
        textColor = context.res.colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 2.0,
      ),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: backgroundColor,
      ),
      child: Text(
        label,
        style: context.res.styles.caption3.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
