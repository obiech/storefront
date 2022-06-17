import 'package:dropezy_proto/v1/order/order.pbenum.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../cart_checkout/index.dart';
import '../../domain/models/order_model.dart';
import '../../widgets/order_widgets.dart';

part 'keys.dart';
part 'views/order_detail_view.dart';

/// Page for desplaying order details from [OrderModel]
class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({
    Key? key,
    required this.order,
    this.paymentInformation,
    this.paymentMethod = PaymentMethod.PAYMENT_METHOD_GOPAY,
  }) : super(key: key);

  final OrderModel order;

  // TODO(obella): Retire when payment info is availed as part of order
  final PaymentInformationModel? paymentInformation;
  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsView(order: order);
  }
}
