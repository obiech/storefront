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
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsView(order: order);
  }
}
