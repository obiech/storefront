part of '../widget.dart';

/// Indicator that contains an icon and label for delivery status
class _DeliveryStatusIndicator extends StatelessWidget {
  const _DeliveryStatusIndicator({
    Key? key,
    required this.isActive,
    required this.iconData,
    this.size = 24,
    required this.label,
  }) : super(key: key);

  /// When [isActive] is true, the color will be green.
  /// Otherwise, color will be grey.
  final bool isActive;

  /// Icon to be used to represent this delivery status
  final IconData iconData;

  /// Icon size
  final double size;

  /// Label shown below the icon
  final String label;

  @override
  Widget build(BuildContext context) {
    final Color color =
        isActive ? context.res.colors.green : context.res.colors.grey3;
    return Column(
      children: [
        Icon(
          iconData,
          size: size,
          color: color,
        ),
        SizedBox(height: context.res.dimens.spacingSmall),
        Text(
          label,
          style: context.res.styles.caption3.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
