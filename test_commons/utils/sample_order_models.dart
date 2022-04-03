import 'package:storefront_app/features/order/domain/models/order_model.dart';

import '../fixtures/order/order_models.dart';

/// Returns a list of sample [OrderModel]s
List<OrderModel> get sampleOrderModels =>
    [orderAwaitingPayment, orderPaid, orderInDelivery, orderArrived];
