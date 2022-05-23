import 'package:flutter/material.dart';

import '../../core.dart';

/// [TextButton] with predefined Dropezy theme.
class DropezyTextButton extends StatelessWidget {
  const DropezyTextButton({
    Key? key,
    required this.label,
    this.textStyle,
    this.leading,
    this.trailing,
    required this.onPressed,
  }) : super(key: key);

  /// Button text
  final String label;

  /// Optional text style for [label].
  ///
  /// When null, defaults to
  /// ```
  /// context.res.styles.caption2.copyWith(
  ///   color: context.res.colors.blue,
  ///   fontWeight: FontWeight.w600,
  /// ).withLineHeight(16)
  /// ```
  final TextStyle? textStyle;

  /// Widget shown to the left of [label]
  final Widget? leading;

  /// Widget shown to the right of [label]
  final Widget? trailing;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: textStyle ??
                context.res.styles.caption2
                    .copyWith(
                      color: context.res.colors.blue,
                      fontWeight: FontWeight.w600,
                    )
                    .withLineHeight(16),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
