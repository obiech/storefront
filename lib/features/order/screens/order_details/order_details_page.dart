import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/models/order_model.dart';
import '../../widgets/order_widgets.dart';

/// Screen for desplaying order details from [OrderModel]
class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.orderDetails,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            OrderStatusHeader(
              orderId: order.id,
              orderCreationTime: order.orderDate,
              orderStatus: order.status,
              estimatedArrivalTime: order.estimatedArrivalTime,
            ),
            const ThickDivider(),
            if (order.status == OrderStatus.inDelivery ||
                order.status == OrderStatus.arrived) ...[
              DriverAndRecipientSection(
                driverModel: order.driver!,
                recipientModel: order.recipient,
              ),
              const ThickDivider(),
            ],
            OrderDetailsSection(products: order.productsBought),
            const ThickDivider(),
            OrderPaymentSummary(
              totalSavings:
                  (int.parse(order.discount) + int.parse(order.deliveryFee))
                      .toString(),
              discountFromItems: order.discount,
              subtotal: order.subTotal,
              deliveryFee: order.deliveryFee,
              isFreeDelivery: true,
              paymentMethod: 'Gopay',
              grandTotal: order.total,
            ),
          ],
        ),
      ),
    );
  }
}
