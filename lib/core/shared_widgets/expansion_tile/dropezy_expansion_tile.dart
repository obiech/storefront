import 'package:flutter/material.dart';
import '../../core.dart';

part 'parts/bulletin_tile.dart';

/// This class is used to create An [ExpansionTile].
///
/// To create [ExpansionTile] with children displayed as
/// bulletin points, make use of the [DropezyExpansionTile.bulletin]
class DropezyExpansionTile extends StatelessWidget {
  /// The primary content of the list item.
  final String title;

  /// The widgets that is displayed when the tile expands.
  final Widget subtitle;

  /// Specifies padding for [subtitle].
  /// When the value is null, the value of [subtitlePadding]
  /// is given [bottomPadding] of 20.
  final EdgeInsetsGeometry? subtitlePadding;

  const DropezyExpansionTile({
    required this.title,
    required this.subtitle,
    this.subtitlePadding,
    Key? key,
  }) : super(key: key);

  /// Used to create ExpansionTile with children in listed points.
  factory DropezyExpansionTile.bulletin({
    /// The primary content of the list item.
    /// Typically a [Text] widget.
    required String title,

    /// The Sub Header of the [bulletin].
    ///
    /// The widget that is displayed as a
    /// sub header when the tile is tap.
    required Widget bulletinSubtitle,

    /// The Widgets that are displayed as bulletin when
    /// the tile is taped.
    required List<String> bulletins,

    /// Specifies padding for [bulletin].
    /// When the value is null, the value of [bulletinPadding]
    /// is given [bottomPadding] of 20.
    EdgeInsetsGeometry? bulletinPadding,
  }) {
    return DropezyExpansionTile(
      title: title,
      subtitlePadding: bulletinPadding,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bulletinSubtitle,
          const SizedBox(
            height: 7,
          ),
          ...bulletins
              .map(
                (text) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: _BulletinTile(bulletinText: text),
                ),
              )
              .toList()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style:
            context.res.styles.caption1.copyWith(fontWeight: FontWeight.w500),
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      iconColor: context.res.colors.black,
      textColor: context.res.colors.black,
      childrenPadding: subtitlePadding ??
          EdgeInsets.only(
            bottom: context.res.dimens.pagePadding,
          ),
      children: [subtitle],
    );
  }
}
