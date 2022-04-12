import 'package:dropezy_proto/v1/cart/cart.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:uuid/uuid.dart';

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
          child: BlocBuilder<CartBodyBloc, CartBodyState>(
            builder: (context, state) {
              if (state is CartBodyStarted) {
                final request = SummaryRequest(storeId: const Uuid().v4());
                context.read<CartBodyBloc>().add(OnLoadCartBody(request));

                return const CircularProgressIndicator();
              } else if (state is CartSummaryLoaded) {
                return Column(
                  children: [
                    SizedBox(height: res.dimens.spacingXxlarge),
                    OrderPaymentSummary(
                      totalSavings: '8000000',
                      subtotal: state.summary.subTotal,
                      discountFromItems: state.summary.discount,
                      isFreeDelivery: state.summary.isFreeDelivery,
                      deliveryFee: state.summary.deliveryFee,
                      grandTotal: state.summary.total,
                    ),
                  ],
                );
              } else if (state is CartBodyFailed) {
                return Text(state.exception.toString());
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        )
      ],
    );
  }
}
