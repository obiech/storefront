import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/pages/order_history/order_history_page.dart';

class OrderHistoryFinders {
  static Finder get loadingWidget =>
      find.byKey(const ValueKey(OrderHistoryKeys.loadingWidget));

  static Finder get listWidget =>
      find.byKey(const ValueKey(OrderHistoryKeys.orderListWidget));

  static Finder get noOrdersWidget =>
      find.byKey(const ValueKey(OrderHistoryKeys.noOrdersWidget));

  static Finder get errorWidget =>
      find.byKey(const ValueKey(OrderHistoryKeys.errorWidget));
}
