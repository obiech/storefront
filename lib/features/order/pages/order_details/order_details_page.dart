import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../di/injection.dart';
import '../../../cart_checkout/index.dart';
import '../../index.dart';

part 'keys.dart';
part 'views/order_detail_view.dart';
part 'wrapper.dart';

/// Page for desplaying order details from [OrderModel]
class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OrderDetailsView();
  }
}
