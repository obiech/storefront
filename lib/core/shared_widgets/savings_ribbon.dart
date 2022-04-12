import 'package:flutter/material.dart';

import './semi_circle_clipped_widget.dart';
import '../core.dart';

/// Ribbon-like widget that displays amount saved by user in
/// this order.
class SavingsRibbon extends StatelessWidget {
  const SavingsRibbon({
    Key? key,
    required this.totalSavings,
  }) : super(key: key);

  final String totalSavings;

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return SemiCircleClippedWidget(
      child: Container(
        height: 40,
        color: res.colors.savingsRibbonGreen,
        alignment: Alignment.center,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${res.strings.wowYouManagedToSave} ',
                style: res.styles.caption2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: totalSavings.toCurrency(),
                style: res.styles.caption2.copyWith(
                  color: res.colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' !',
                style: res.styles.caption2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
