import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../../index.dart';

/// Widgets that will be shown at the bottom of [OrderDetailsPage]
/// By default it only shows Contact Support button
///
class OrderActions extends StatelessWidget {
  const OrderActions({
    Key? key,
    this.showReorderButton = false,
  }) : super(key: key);

  // toggle to show Reorder button
  final bool showReorderButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: context.res.styles.bottomSheetStyle,
      child: Row(
        children: [
          Expanded(
            child: ContactSupportButton(onPressed: _contactSupport),
          ),
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

  void _contactSupport() {
    // TODO (leovinsen): add contact support method
  }

  void _initiateReorderFlow() {
    // TODO (leovinsen): add re-order flow
  }
}
