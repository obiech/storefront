import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storefront_app/core/core.dart';

import '../../../order/widgets/payment_summary/order_payment_summary.dart';
import '../../index.dart';

part 'parts/cart_body_empty.dart';
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
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CartAddressSelection(
                  key: CartBodyWidgetKeys.addressSelection,
                ),
                const ThickDivider(),
                SizedBox(height: res.dimens.pagePadding),
                // TODO (leovinsen): Refactor with less if elses
                if (state.cart.isEmpty) const CartBodyEmpty(),
                if (state.cart.inStockItems.isNotEmpty) ...[
                  CartItemsSection(
                    key: CartBodyWidgetKeys.cartItemsInStock,
                    items: state.cart.inStockItems,
                    title: context.res.strings.cart,
                  ),
                  const SizedBox(height: 16),
                ],
                if (state.cart.outOfStockItems.isNotEmpty) ...[
                  CartItemsSection(
                    key: CartBodyWidgetKeys.cartItemsOutOfStock,
                    items: state.cart.outOfStockItems,
                    title: context.res.strings.outOfStockItems,
                  ),
                  const SizedBox(height: 16),
                ],
                if (!state.cart.isEmpty)
                  _PaymentSummary(
                    isLoading: state.isCalculatingSummary,
                    paymentSummary: state.cart.paymentSummary,
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

/// Contains widgets for payment summary & its skeleton
/// to avoid complex if else in [CartBodyWidget] build method.
class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({
    Key? key,
    required this.paymentSummary,
    required this.isLoading,
  }) : super(key: key);

  final CartPaymentSummaryModel paymentSummary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ?
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
        : const OrderPaymentSummarySkeleton(
            key: CartBodyWidgetKeys.paymentSummaryLoading,
          );
  }
}
