import 'package:flutter/material.dart';

import '../../res/resources.dart';

extension BuildContextX on BuildContext {
  Resources get res => Resources.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, {
    Color? color,
    Widget? leading,
    Duration duration = const Duration(seconds: 3),
  }) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: duration,
        content: Container(
          decoration: BoxDecoration(
            color: color ?? res.colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(
            vertical: res.dimens.spacingMedium,
            horizontal: res.dimens.spacingMiddle,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading,
                const SizedBox(
                  width: 8,
                )
              ],
              Text(
                message,
                style: res.styles.button.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
