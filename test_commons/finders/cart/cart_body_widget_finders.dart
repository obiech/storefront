import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/index.dart';

class CartBodyWidgetFinders {
  static Finder get cartBodyLoading => find.byWidgetPredicate(
        (widget) =>
            widget.key == CartBodyWidgetKeys.loading &&
            widget is CartBodyLoading,
        description: 'Loading widget of CartBodyWidget',
      );
  static Finder get cartItems => find.byWidgetPredicate(
        (widget) =>
            widget.key == CartBodyWidgetKeys.cartItems &&
            widget is CartItemsSection,
        description: 'Cart items section',
      );

  static Finder get paymentSummary => find.byWidgetPredicate(
        (widget) =>
            widget.key == CartBodyWidgetKeys.paymentSummary &&
            widget is OrderPaymentSummary,
        description: 'Cart payment summary',
      );

  static Finder get paymentSummaryLoading => find.byWidgetPredicate(
        (widget) =>
            widget.key == CartBodyWidgetKeys.paymentSummaryLoading &&
            widget is OrderPaymentSummarySkeleton,
        description: 'Loading widget of cart payment summary',
      );

  // TODO: improve widget predicate when design is finalized
  static Finder get failedToLoad => find.byKey(CartBodyWidgetKeys.failedToLoad);
}
