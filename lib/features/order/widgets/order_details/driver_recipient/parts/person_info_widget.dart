part of '../widget.dart';

/// Widget for displaying information of a person (e.g. driver or recipient)
///
/// From left to right:
///
/// - Rounded profile image
/// - Column containing [personName] and [additionalDescription]
/// - an optional [trailing] widget
class _PersonInfoWidget extends StatelessWidget {
  const _PersonInfoWidget({
    Key? key,
    required this.imageUrl,
    required this.personName,
    required this.additionalDescription,
    this.trailing,
  }) : super(key: key);

  final String imageUrl;

  final String personName;

  /// additional text shown below [personName]
  final String additionalDescription;

  /// Optional widget to show at the end.
  /// Additionally, [trailing] will have a padding of 12 dp to its left.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: SizedBox(
            width: 40,
            height: 40,
            child: DropezyImage(
              url: imageUrl,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                personName,
                style: context.res.styles.caption1.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 22 / 14,
                ),
              ),
              Text(
                additionalDescription,
                style: context.res.styles.caption2.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 20 / 12,
                ),
              )
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ]
      ],
    );
  }
}
