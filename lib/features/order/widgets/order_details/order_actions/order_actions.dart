import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../../index.dart';

/// Widgets that will be shown at the bottom of [OrderDetailsPage]
/// By default it only shows Contact Support button
///
class OrderActions extends StatelessWidget {
  const OrderActions({
    Key? key,
    required this.order,
    this.showReorderButton = false,
  }) : super(key: key);

  // toggle to show Reorder button
  final bool showReorderButton;

  final OrderModel order;

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
          if (order.status.isAwaitingPayment) ...[
            const SizedBox(width: 8),
            Expanded(
              child: PayNowButton(
                onPressed: () {
                  context.pushRoute(
                    PaymentInstructionsRoute(order: order),
                  );
                },
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
}
