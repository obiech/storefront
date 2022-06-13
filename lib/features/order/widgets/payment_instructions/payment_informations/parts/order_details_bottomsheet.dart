part of '../payment_information_section.dart';

/// BottomSheet for order details contains:
/// - Summary of transactions [OrderPaymentSummary]
/// - List of product bought [OrderDetailsSection]
/// - Recipient's address [DeliveryAddressDetail]
class OrderDetailsBottomSheet extends StatelessWidget {
  const OrderDetailsBottomSheet({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return DropezyBottomSheet(
      marginTop: 28,
      padding: const EdgeInsets.only(bottom: 4),
      child: FractionallySizedBox(
        heightFactor: 0.75,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TODO : update when new order model is available
              OrderPaymentSummary(
                totalSavings:
                    (int.parse(order.discount) + int.parse(order.deliveryFee))
                        .toString(),
                discountFromItems: order.discount,
                subtotal: order.subTotal,
                deliveryFee: order.deliveryFee,
                isFreeDelivery: true,
                paymentMethod: 'BCA Virtual Account',
                grandTotal: order.total,
              ),
              const ThickDivider(),
              OrderDetailsSection(products: order.productsBought),
              const ThickDivider(),
              DeliveryAddressDetail(
                heading: context.res.strings.deliveryLocation,
                address: order.recipientAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
