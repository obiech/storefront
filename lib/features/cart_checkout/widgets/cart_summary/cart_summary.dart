import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'parts/summary_details.dart';

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
            child: Skeleton(
              isLoading: state.isCalculatingSummary,
              skeleton: SkeletonItem(
                child: CartSummaryDetails(
                  itemCount: cartModel.items.length,
                  hasDiscount: cartModel.hasDiscount,
                  total: cartModel.paymentSummary.total,
                  subTotal: cartModel.paymentSummary.subTotal,
                  isLoading: state.isCalculatingSummary,
                ),
              ),
              child: CartSummaryDetails(
                itemCount: cartModel.items.length,
                hasDiscount: cartModel.hasDiscount,
                total: cartModel.paymentSummary.total,
                subTotal: cartModel.paymentSummary.subTotal,
                isLoading: state.isCalculatingSummary,
              ),
            ),
          );
        } else if (state is CartLoading) {
          return Container(
            decoration: BoxDecoration(
              color: res.colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
            child: const SkeletonItem(
              child: CartSummaryDetails(
                itemCount: 0,
                hasDiscount: false,
                total: '000',
                subTotal: '000',
                isLoading: true,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}