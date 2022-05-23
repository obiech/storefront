import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../../order/widgets/payment_summary/order_payment_summary.dart';
import '../../index.dart';

part 'parts/cart_body_loading.dart';
part 'parts/keys.dart';

/// Widget that responsible to represent all components of cart main page body
class CartBodyWidget extends StatelessWidget {
  const CartBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          final paymentSummary = state.cart.paymentSummary;

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: res.dimens.spacingXxlarge),
                CartItemsSection(
                  key: CartBodyWidgetKeys.cartItemsInStock,
                  items: state.cart.inStockItems,
                  title: context.res.strings.cart,
                ),
                const SizedBox(height: 16),
                if (state.cart.outOfStockItems.isNotEmpty) ...[
                  CartItemsSection(
                    key: CartBodyWidgetKeys.cartItemsOutOfStock,
                    items: state.cart.outOfStockItems,
                    title: context.res.strings.outOfStockItems,
                  ),
                  const SizedBox(height: 16),
                ],
                if (!state.isCalculatingSummary)
                  //TODO (leovinsen): Have a separate field for savings once other
                  // discounts are added in backend
                  OrderPaymentSummary(
                    key: CartBodyWidgetKeys.paymentSummary,
                    totalSavings: paymentSummary.discount == '000'
                        ? null
                        : paymentSummary.discount,
                    subtotal: paymentSummary.subTotal,
                    discountFromItems: paymentSummary.discount == '000'
                        ? null
                        : paymentSummary.discount,
                    isFreeDelivery: paymentSummary.isFreeDelivery,
                    deliveryFee: paymentSummary.deliveryFee,
                    grandTotal: paymentSummary.total,
                  )
                else
                  const OrderPaymentSummarySkeleton(
                    key: CartBodyWidgetKeys.paymentSummaryLoading,
                  ),
              ],
            ),
          );
        } else if (state is CartLoading) {
          return const CartBodyLoading(
            key: CartBodyWidgetKeys.loading,
          );
        } else if (state is CartFailedToLoad) {
          //TODO: Improve error handling when design is available
          return const Center(
            key: CartBodyWidgetKeys.failedToLoad,
            child: DropezyEmptyState(message: 'Cart failed to load'),
          );
        }

        return const SizedBox();
      },
    );
  }
}
