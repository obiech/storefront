import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../index.dart';

/// Displays a total summary of price & discounts
/// for items in cart or product list
class CartSummary extends StatelessWidget {
  const CartSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          final cartModel = state.cart;
          return Container(
            decoration: BoxDecoration(
              color: res.colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
            child: Row(
              children: [
                DropezyBadge(
                  count: cartModel.items.length,
                  icon: DropezyIcons.cart,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Row(
                    children: [
                      if (cartModel.hasDiscount)
                        Text(
                          cartModel.paymentSummary.subTotal.toCurrency(),
                          style: res.styles.discountText.copyWith(
                            color: res.colors.grey2,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        cartModel.paymentSummary.total.toCurrency(),
                        style: res.styles.productTileProductName.copyWith(
                          color: res.colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: .6,
                    ),
                    child: DropezyButton.primary(
                      label: res.strings.viewCart,
                      onPressed: () {
                        context.router.push(const CartCheckoutRoute());
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          // TODO(obella): Create cart summary loading
          return const SizedBox();
        }
      },
    );
  }
}
