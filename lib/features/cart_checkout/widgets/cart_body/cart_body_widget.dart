import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../../order/widgets/payment_summary/order_payment_summary.dart';
import '../../index.dart';

/// Widget that responsible to represent all components of cart main page body
class CartBodyWidget extends StatelessWidget {
  const CartBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return ListView(
      children: [
        Center(
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded) {
                return Column(
                  children: [
                    SizedBox(height: res.dimens.spacingXxlarge),
                    if (state.cart.items.isEmpty)
                      const DropezyEmptyState(
                        message: 'Cart is empty',
                      )
                    else
                      OrderPaymentSummary(
                        //TODO (leovinsen): Have a separate field for savings once other
                        // discounts are added in backend
                        totalSavings: state.cart.paymentSummary.discount,
                        subtotal: state.cart.paymentSummary.subTotal,
                        discountFromItems: state.cart.paymentSummary.discount,
                        isFreeDelivery:
                            state.cart.paymentSummary.isFreeDelivery,
                        deliveryFee: state.cart.paymentSummary.deliveryFee,
                        grandTotal: state.cart.paymentSummary.total,
                      ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        )
      ],
    );
  }
}
