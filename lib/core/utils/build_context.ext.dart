import 'package:flutter/material.dart';

import '../../res/resources.dart';

extension BuildContextX on BuildContext {
  Resources get res => Resources.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, {
    Color? color,
  }) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            color: color ?? res.colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(
            vertical: res.dimens.spacingMedium,
            horizontal: res.dimens.spacingMiddle,
          ),
          child: Text(
            message,
            style: res.styles.button.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
