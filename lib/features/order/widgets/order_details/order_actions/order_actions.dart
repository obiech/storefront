import 'package:auto_route/auto_route.dart';
import 'package:dropezy_proto/v1/order/order.pbenum.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/domain/utils/launch_go_pay.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../index.dart';

/// Widgets that will be shown at the bottom of [OrderDetailsPage]
/// By default it only shows Contact Support button
///
// TODO: Improve by using list of enum to control buttons shown when Reorder flow is implemented
class OrderActions extends StatelessWidget {
  const OrderActions({
    Key? key,
    required this.order,
    this.showReorderButton = false,
    this.showPayButton = true,
    this.paymentInformation,
    this.paymentMethod = PaymentMethod.PAYMENT_METHOD_GOPAY,
    this.launchGoPay = const LaunchGoPay(),
  }) : super(key: key);

  // toggle to show Reorder button
  final bool showReorderButton;

  // to deactivate Pay button inside [PaymentInstructionsPage]
  final bool showPayButton;

  final OrderModel order;

  // TODO(obella): Retire when payment info is availed as part of order
  final PaymentInformationModel? paymentInformation;
  final PaymentMethod paymentMethod;

  // Gojek link launcher
  final LaunchGoPay launchGoPay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: context.res.styles.bottomSheetStyle,
      child: Row(
        children: [
          Expanded(
            child: ContactSupportButton(
              onPressed: () {
                context.pushRoute(
                  const HelpRoute(),
                );
              },
            ),
          ),
          if (order.status.isAwaitingPayment && showPayButton) ...[
            const SizedBox(width: 8),
            Expanded(
              child: PayNowButton(
                key: const ValueKey(
                  OrderDetailsPageKeys.buttonPayNow,
                ),
                onPressed: () => _payNow(context),
              ),
            ),
          ],
          if (showReorderButton) ...[
            const SizedBox(width: 8),
            Expanded(
              child: DropezyButton.primary(
                key: const ValueKey(
                  OrderDetailsPageKeys.buttonOrderAgain,
                ),
                label: context.res.strings.orderAgain,
                onPressed: _initiateReorderFlow,
                textStyle: context.res.styles.caption1.copyWith(
                  color: context.res.colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ],
      ),
    );
  }

  void _initiateReorderFlow() {
    // TODO (leovinsen): add re-order flow
  }

  /// Pay now
  void _payNow(BuildContext context) {
    if (paymentInformation == null) {
      context.showToast('Payment Info in order still in work');
      return;
    }

    switch (paymentMethod) {
      case PaymentMethod.PAYMENT_METHOD_GOPAY:
        launchGoPay(paymentInformation?.deeplink ?? '');
        break;
      case PaymentMethod.PAYMENT_METHOD_VA_BCA:
        context.pushRoute(
          PaymentInstructionsRoute(
            order: order,
            paymentInformation: paymentInformation,
            paymentMethod: paymentMethod,
          ),
        );
        break;
      default:
        // TODO(obella): Message for unspecified payment method
        break;
    }
  }
}
