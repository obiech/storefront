import 'dart:io';

import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../index.dart';
import 'keys.dart';

/// Handles payment method checkout and deep-linking
class CheckoutButton extends StatelessWidget {
  const CheckoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return BlocConsumer<PaymentCheckoutCubit, PaymentCheckoutState>(
      listener: (context, state) async {
        // Launch payment link
        if (state is LoadedPaymentCheckout) {
          switch (state.paymentResults.paymentMethod) {
            case PaymentMethod.PAYMENT_METHOD_GOPAY:
              await _launchCheckoutLink(
                state.paymentResults.paymentInformation.deeplink!,
              );
              break;
            case PaymentMethod.PAYMENT_METHOD_VA_BCA:
              // TODO(obella): Handle BCA result.
              break;
            default:
              break;
          }
        } else if (state is ErrorLoadingPaymentCheckout) {
          context.showToast(
            state.message,
            color: res.colors.red,
          );
        }
      },
      builder: (context, checkoutState) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return BlocBuilder<PaymentMethodCubit, PaymentMethodState>(
              builder: (context, paymentMethodState) {
                final isCalculatingSummary =
                    cartState is CartLoaded && cartState.isCalculatingSummary;
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
                          !isCalculatingSummary
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

  Future<void> _launchCheckoutLink(String link) async {
    try {
      final opened = await launch(link);

      if (!opened) {
        throw PlatformException(code: 'ACTIVITY_NOT_FOUND');
      }
    } on PlatformException catch (e) {
      if (e.code == 'ACTIVITY_NOT_FOUND') {
        /// TODO - Handle different payment methods
        await launch(
          Platform.isAndroid
              ? 'https://play.google.com/store/apps/details?id=com.gojek.app'
              : 'https://apps.apple.com/us/app/gojek/id944875099',
        );
      }
    }
  }
}
