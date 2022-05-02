import 'package:flutter/material.dart';

import '../../res/resources.dart';
import '../dropezy_icons.dart';

/// Is designed like a Material [Chip].
class DropezyChip extends StatelessWidget {
  const DropezyChip({
    Key? key,
    required this.label,
    this.textStyle,
    required this.backgroundColor,
    this.leading,
  }) : super(key: key);

  /// Contents for [Text] widget.
  final String label;

  /// style for [Text] widget.
  final TextStyle? textStyle;

  /// background color for the chip.
  final Color backgroundColor;

  /// An optional widget at the left side before [label].
  /// For example, an icon.
  final Widget? leading;

  /// Used for displaying estimated delivery duration
  factory DropezyChip.deliveryDuration({
    required Resources res,
    required int minutes,
  }) {
    return DropezyChip(
      label: res.strings.minutes(minutes),
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.blue,
      ),
      backgroundColor: const Color(0xFFDEEBFF),
      leading: Icon(
        DropezyIcons.delivery,
        size: 16,
        color: res.colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: backgroundColor,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
