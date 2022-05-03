import 'package:flutter/material.dart';
import 'package:storefront_app/core/shared_widgets/_exporter.dart';

import '../../../core/utils/build_context.ext.dart';
import '../domain/models/order_model.dart';

/// Maps [OrderStatus] into [DropezyChip]s
/// for displaying current order status.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({
    Key? key,
    required this.orderStatus,
  }) : super(key: key);

  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    switch (orderStatus) {
      case OrderStatus.awaitingPayment:
        return DropezyChip.awaitingPayment(res: context.res);
      case OrderStatus.paid:
        return DropezyChip.inProcess(res: context.res);
      case OrderStatus.inDelivery:
        return DropezyChip.inDelivery(res: context.res);
      case OrderStatus.arrived:
        return DropezyChip.arrivedAtDestination(res: context.res);
      case OrderStatus.cancelled:
        return DropezyChip.cancelled(res: context.res);
      case OrderStatus.failed:
        return DropezyChip.failed(res: context.res);
      case OrderStatus.unspecified:
        return DropezyChip.unspecified(res: context.res);
    }
  }
}
