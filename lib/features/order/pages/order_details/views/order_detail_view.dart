part of '../order_details_page.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.orderDetails,
      child: SafeArea(
        child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
            if (state is LoadingOrderDetails) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const OrderStatusHeaderLoading(),
                          const ThickDivider(),
                          const OrderDetailsSectionLoading(),
                          Divider(
                            indent: context.res.dimens.pagePadding,
                            endIndent: context.res.dimens.pagePadding,
                            thickness: 2,
                            height: 1,
                            color: context.res.colors.dividerColor,
                          ),
                          const DeliveryAddressDetailSkeleton(),
                          const ThickDivider(),
                          SizedBox(height: context.res.dimens.pagePadding),
                          const OrderPaymentSummarySkeleton(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is LoadedOrderDetails) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OrderStatusHeader(
                            orderId: state.order.id,
                            orderCreationTime: state.order.orderDate,
                            orderStatus: state.order.status,
                            estimatedArrivalTime:
                                state.order.estimatedArrivalTime,
                            paymentCompletedTime:
                                state.order.paymentCompletedTime,
                            pickupTime: state.order.pickupTime,
                            orderCompletedTime: state.order.orderCompletionTime,
                          ),
                          const ThickDivider(),
                          if (state.order.status == OrderStatus.inDelivery ||
                              state.order.status == OrderStatus.arrived) ...[
                            DriverAndRecipientSection(
                              driverModel: state.order.driver,
                              recipientModel: state.order.recipient,
                            ),
                            const ThickDivider(),
                          ],
                          OrderDetailsSection(
                            products: state.order.productsBought,
                          ),
                          Divider(
                            indent: context.res.dimens.pagePadding,
                            endIndent: context.res.dimens.pagePadding,
                            thickness: 2,
                            height: 1,
                            color: context.res.colors.dividerColor,
                          ),
                          DeliveryAddressDetail(
                            heading: context.res.strings.deliveryLocation,
                            address: state.order.recipientAddress,
                          ),
                          const ThickDivider(),
                          OrderPaymentSummary(
                            totalSavings: (int.parse(state.order.discount) +
                                    int.parse(state.order.deliveryFee))
                                .toString(),
                            discountFromItems: state.order.discount,
                            subtotal: state.order.subTotal,
                            deliveryFee: state.order.deliveryFee,
                            isFreeDelivery: true,
                            paymentMethod:
                                state.order.paymentMethod.paymentInfo.title,
                            grandTotal: state.order.total,
                          ),
                        ],
                      ),
                    ),
                  ),
                  OrderActions(
                    order: state.order,
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
