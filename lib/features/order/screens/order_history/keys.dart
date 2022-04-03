part of 'order_history_screen.dart';

/// [Key] names used in [OrderHistoryScreen]
class OrderHistoryKeys {
  static const _base = 'OrderHistoryScreen';

  /// Widget responsible for displaying Loading UI
  static const loadingWidget = '${_base}_loading';

  /// Widget responsible for displaying List of orders
  /// i.e. [OrderHistoryList]
  static const orderListWidget = '${_base}_orderList';

  /// Widget shown when there are no orders in user's history
  static const noOrdersWidget = '${_base}_noOrders';

  /// Widget responsible for displaying error message to the user
  static const errorWidget = '${_base}_error';
}
