import 'package:flutter/material.dart';

import '../../core/constants/dropezy_colors.dart';
import '../../core/constants/dropezy_text_styles.dart';

class DropezyButton extends StatelessWidget {
  const DropezyButton({
    Key? key,
    required this.label,
    required this.textStyle,
    required this.backgroundColor,
    this.leftIcon,
    this.rightIcon,
    this.onPressed,
    this.padding,
    this.isLoading = false,
  }) : super(key: key);

  factory DropezyButton.primary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    TextStyle? textStyle,
    EdgeInsets? padding,
    bool isLoading = false,
    Widget? leftIcon,
    Widget? rightIcon,
  }) {
    return DropezyButton(
      key: key,
      label: label,
      backgroundColor: DropezyColors.blue,
      onPressed: isLoading ? () {} : onPressed,
      textStyle: textStyle ??
          DropezyTextStyles.button.copyWith(
            color: DropezyColors.white,
          ),
      padding: padding,
      isLoading: isLoading,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
    );
  }

  factory DropezyButton.secondary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    TextStyle? textStyle,
    EdgeInsets? padding,
    Widget? leftIcon,
    Widget? rightIcon,
  }) {
    return DropezyButton(
      key: key,
      label: label,
      backgroundColor: DropezyColors.white,
      onPressed: onPressed,
      textStyle: textStyle ??
          DropezyTextStyles.button.copyWith(
            color: DropezyColors.blue,
          ),
      padding: padding,
      isLoading: isLoading,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
    );
  }

  factory DropezyButton.blueTint({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    TextStyle? textStyle,
    EdgeInsets? padding,
    Widget? leftIcon,
    Widget? rightIcon,
  }) {
    return DropezyButton(
      key: key,
      label: label,
      backgroundColor: DropezyColors.lightBlue,
      onPressed: onPressed,
      textStyle: textStyle ??
          DropezyTextStyles.button.copyWith(
            color: DropezyColors.blue,
          ),
      padding: padding,
      isLoading: isLoading,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
    );
  }

  final String label;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  /// optional icon shown on the left of label
  final Widget? leftIcon;

  /// optional icon shown on the right of label
  final Widget? rightIcon;

  /// Button custom padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        elevation: 0,
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
        shape: const StadiumBorder(),
      ),
      child: !isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leftIcon != null) ...[
                  leftIcon ?? const SizedBox.shrink(),
                  const SizedBox(
                    width: 4.0,
                  ),
                ],
                Text(
                  label,
                  style: textStyle,
                ),
                if (rightIcon != null) ...[
                  const SizedBox(
                    width: 4.0,
                  ),
                  rightIcon ?? const SizedBox.shrink(),
                ],
              ],
            )
          : _loadingIndicator(),
    );
  }

  Widget _loadingIndicator() => const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
}
