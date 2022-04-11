import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/models/order_model.dart';
import '../../widgets/order_details/section.dart';
import '../../widgets/payment_summary/order_payment_summary.dart';

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
            OrderDetailsSection(products: order.productsBought),
            const Divider(
              color: Color(0xFFEEF0F2),
              endIndent: 0,
              indent: 0,
              thickness: 8,
            ),
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
