import 'package:auto_route/auto_route.dart';
import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';
import 'keys.dart';

/// Handles payment method checkout and deep-linking
class CheckoutButton extends StatelessWidget {
  const CheckoutButton({Key? key, this.launchGoPay = const LaunchGoPay()})
      : super(key: key);

  final LaunchGoPay launchGoPay;

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return BlocConsumer<PaymentCheckoutCubit, PaymentCheckoutState>(
      listener: (context, state) async {
        // Launch payment link
        if (state is LoadedPaymentCheckout) {
          // Reload Cart
          context.read<CartBloc>().add(const LoadCart());

          final paymentResults = state.order;

          // Open GoPay app
          switch (paymentResults.paymentMethod) {
            case PaymentMethod.PAYMENT_METHOD_GOPAY:
              context.router.replaceAll([
                const MainRoute(),
                OrderRouter(
                  children: [
                    const OrderHistoryRoute(),
                    OrderDetailsRoute(id: paymentResults.id)
                  ],
                )
              ]);

              launchGoPay(paymentResults.paymentInformation.deeplink ?? '');
              break;
            case PaymentMethod.PAYMENT_METHOD_VA_BCA:
              context.router.replaceAll([
                const MainRoute(),
                const OrderRouter(
                  children: [
                    OrderHistoryRoute(),
                  ],
                ),
                PaymentInstructionsRoute(order: paymentResults),
              ]);
              break;
            default:
              // Error from backend with Undefined Payment Method
              break;
          }
        } else if (state is ErrorLoadingPaymentCheckout) {
          context.showToast(
            state.message,
            color: res.colors.red,
          );

          // Refresh cart on error
          context.read<CartBloc>().add(const LoadCart());

          /// TODO(obella): Handle [FailedPreconditionFailure] message
          /// https://www.figma.com/file/1MehrTeZ2q50qqOO6XYvTR/Final-UI?node-id=5914%3A47887
        }
      },
      builder: (context, checkoutState) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return BlocBuilder<PaymentMethodCubit, PaymentMethodState>(
              builder: (context, paymentMethodState) {
                return DropezyButton.primary(
                  key: const ValueKey(CheckoutKeys.buy),
                  label: res.strings.pay,
                  textStyle: res.styles.button.copyWith(fontSize: 14),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  isLoading: checkoutState is LoadingPaymentCheckout,
                  onPressed: paymentMethodState is LoadedPaymentMethods &&
                          cartState.isValidForCheckout
                      ? () async =>
                          context.read<PaymentCheckoutCubit>().checkoutPayment(
                                paymentMethodState.activePaymentMethod,
                              )
                      : null,
                );
              },
            );
          },
        );
      },
    );
  }
}
