import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/models/order_model.dart';
import '../../widgets/order_widgets.dart';

part 'keys.dart';

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
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                      paymentCompletedTime: order.paymentCompletedTime,
                      pickupTime: order.pickupTime,
                      orderCompletedTime: order.orderCompletionTime,
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
                      totalSavings: (int.parse(order.discount) +
                              int.parse(order.deliveryFee))
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
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: context.res.styles.bottomSheetStyle,
              child: order.status == OrderStatus.arrived
                  ? Row(
                      children: [
                        Expanded(
                          child:
                              ContactSupportButton(onPressed: _contactSupport),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropezyButton.primary(
                            key: const ValueKey(
                              OrderDetailsPageKeys.buttonOrderAgain,
                            ),
                            label: context.res.strings.orderAgain,
                            onPressed: _initiateReorderFlow,
                            textStyle: context.res.styles.caption1.copyWith(
                              color: context.res.colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ContactSupportButton(onPressed: _contactSupport),
            )
          ],
        ),
      ),
    );
  }

  void _contactSupport() {
    // TODO (leovinsen): add contact support method
  }

  void _initiateReorderFlow() {
    // TODO (leovinsen): add re-order flow
  }
}
