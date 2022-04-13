import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// Rounded [ElevatedButton]
class PillButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Handle button tap
  final Function()? onTap;

  /// Button color
  final Color? color;

  /// Button text color
  final Color? textColor;

  /// Show that button is loading
  final bool isLoading;

  /// Progress color
  final Color? progressColor;

  /// Size of the progress loader
  final double progressSize;

  const PillButton({
    Key? key,
    this.onTap,
    required this.text,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.progressColor,
    this.progressSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return ElevatedButton(
      onPressed: isLoading ? () {} : onTap,
      style: ElevatedButton.styleFrom(
        primary: color ?? res.colors.blue,
        textStyle: res.styles.subtitle.copyWith(
          fontSize: 11,
        ),
        onPrimary: textColor ?? res.colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(res.dimens.spacingLarge),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: progressSize,
              width: progressSize,
              child: CircularProgressIndicator(
                color: progressColor ?? res.colors.blue,
                strokeWidth: 2,
              ),
            )
          : Text(text),
    );
  }
}
