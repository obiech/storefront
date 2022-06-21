part of '../order_details_page.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({
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
                        driverModel: order.driver,
                        recipientModel: order.recipient,
                      ),
                      const ThickDivider(),
                    ],
                    OrderDetailsSection(products: order.productsBought),
                    Divider(
                      indent: context.res.dimens.pagePadding,
                      endIndent: context.res.dimens.pagePadding,
                      thickness: 2,
                      height: 1,
                      color: context.res.colors.dividerColor,
                    ),
                    DeliveryAddressDetail(
                      heading: context.res.strings.deliveryLocation,
                      address: order.recipientAddress,
                    ),
                    const ThickDivider(),
                    OrderPaymentSummary(
                      totalSavings: (int.parse(order.discount) +
                              int.parse(order.deliveryFee))
                          .toString(),
                      discountFromItems: order.discount,
                      subtotal: order.subTotal,
                      deliveryFee: order.deliveryFee,
                      isFreeDelivery: true,
                      paymentMethod: order.paymentMethod.paymentInfo.title,
                      grandTotal: order.total,
                    ),
                  ],
                ),
              ),
            ),
            OrderActions(order: order),
          ],
        ),
      ),
    );
  }
}
