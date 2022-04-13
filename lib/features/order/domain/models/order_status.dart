part of 'order_model.dart';

/// Status of an [OrderModel] entity
enum OrderStatus {
  /// Awaiting payment
  awaitingPayment,

  /// Already paid and is being processed by Dark Store
  paid,

  /// Order is being delivered to customer's address
  inDelivery,

  /// Order has arrived at customer's address
  arrived,

  /// Cancelled
  cancelled,

  /// Failed
  failed,

  /// Fallback for unknown status
  unspecified,
}
