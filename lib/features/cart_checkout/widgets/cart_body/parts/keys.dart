part of '../cart_body_widget.dart';

class CartBodyWidgetKeys {
  static const _base = 'CartBodyWidget';

  /// Represents user's shopping cart with
  /// items that are in stock
  static const cartItemsInStock = ValueKey('${_base}_cartItemsInStock');

  /// Represents user's shopping cart with
  /// items that are out of stock
  static const cartItemsOutOfStock = ValueKey('${_base}_cartItemsOutOfStock');

  /// Represents cart payment summary
  static const paymentSummary = ValueKey('${_base}_paymentSummary');

  /// Represents loading widget for the cart payment summary
  static const paymentSummaryLoading =
      ValueKey('${_base}_paymentSummaryLoading');

  /// Widget for state [CartLoading]
  static const loading = ValueKey('${_base}_loading');

  /// Widget for state [CartFailedToLoad]
  static const failedToLoad = ValueKey('${_base}_failedToLoad');
}
