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
      backgroundColor: res.colors.paleBlue,
      leading: Icon(
        DropezyIcons.delivery,
        size: 16,
        color: res.colors.blue,
      ),
    );
  }

  /// Displays text 'Awaiting Payment'
  factory DropezyChip.awaitingPayment({
    required Resources res,
  }) {
    return DropezyChip(
      label: res.strings.awaitingPayment,
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.orange,
      ),
      backgroundColor: res.colors.lightOrange,
    );
  }

  /// Displays text 'In Process'
  factory DropezyChip.inProcess({
    required Resources res,
  }) {
    return DropezyChip(
      label: res.strings.inProcess,
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.deepYellow,
      ),
      backgroundColor: res.colors.paleYellow,
    );
  }

  /// Displays text 'In Delivery'
  factory DropezyChip.inDelivery({
    required Resources res,
  }) {
    return DropezyChip(
      label: res.strings.inDelivery,
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.green,
      ),
      backgroundColor: res.colors.paleGreen,
    );
  }

  /// Displays text 'Arrived At Destination'
  factory DropezyChip.arrivedAtDestination({
    required Resources res,
  }) {
    return DropezyChip(
      label: res.strings.arrivedAtDestination,
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.blue,
      ),
      backgroundColor: res.colors.paleBlue,
    );
  }

  /// Displays text 'Cancelled'
  factory DropezyChip.cancelled({
    required Resources res,
  }) {
    return DropezyChip(
      label: res.strings.cancelled,
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.white,
      ),
      backgroundColor: res.colors.red,
    );
  }

  /// Displays text 'Cancelled'
  factory DropezyChip.failed({
    required Resources res,
  }) {
    return DropezyChip(
      label: res.strings.failed,
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.white,
      ),
      backgroundColor: res.colors.red,
    );
  }

  /// Used for displaying primary chip
  factory DropezyChip.primary({
    required Resources res,
    required String label,
  }) {
    return DropezyChip(
      label: label,
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.blue,
      ),
      backgroundColor: const Color(0xFFD0E3FF),
    );
  }

  /// Displays text 'Unspecified'
  factory DropezyChip.unspecified({
    required Resources res,
  }) {
    return DropezyChip(
      label: res.strings.unspecified,
      textStyle: res.styles.caption3.copyWith(
        fontWeight: FontWeight.w600,
        color: res.colors.white,
      ),
      backgroundColor: res.colors.black,
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
