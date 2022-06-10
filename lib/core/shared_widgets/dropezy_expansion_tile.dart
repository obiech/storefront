import 'package:flutter/material.dart';
import '../core.dart';

/// This class is used to create An [ExpansionTile].
class DropezyExpansionTile extends StatelessWidget {
  /// The primary content of the tile.
  ///
  /// The String displayed as the header/title of the tile
  final String title;

  /// The widgets that is displayed when the tile expands.
  final Widget subtitle;

  /// Specifies padding for [subtitle].
  ///
  /// When the value is null, the value of [subtitlePadding]
  /// is given [bottomPadding] of 20.
  final EdgeInsetsGeometry? subtitlePadding;

  /// Specifies padding for [title].
  ///
  /// When this is null, the value of [titlePadding]
  /// is given [EdgeInsets.zero].
  final EdgeInsetsGeometry? titlePadding;

  const DropezyExpansionTile({
    required this.title,
    required this.subtitle,
    this.titlePadding,
    this.subtitlePadding,
    Key? key,
  }) : super(key: key);

  factory DropezyExpansionTile.textSubtitle({
    Key? key,
    required String title,
    required String subtitle,
  }) {
    return DropezyExpansionTile(
      key: key,
      title: title,
      subtitle: Builder(
        builder: (context) {
          return Text(
            subtitle,
            style: context.res.styles.caption1
                .copyWith(fontWeight: FontWeight.w400)
                .withLineHeight(22),
          );
        },
      ),
    );
  }

  factory DropezyExpansionTile.numberedList({
    Key? key,
    required String title,
    required List<String> contents,
  }) {
    return DropezyExpansionTile(
      key: key,
      title: title,
      subtitle: Column(
        children: List.generate(
          contents.length,
          (index) => _SubtitleItem(
            number: index + 1,
            text: contents[index],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: context.res.styles.caption1.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      tilePadding: titlePadding ?? EdgeInsets.zero,
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

class _SubtitleItem extends StatelessWidget {
  /// The leading number of subtitle
  final int number;

  /// The String displayed
  final String text;

  const _SubtitleItem({
    Key? key,
    required this.number,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.res.dimens.pagePadding,
          child: Text(
            '$number. ',
            style: context.res.styles.caption1
                .copyWith(fontWeight: FontWeight.w400)
                .withLineHeight(28),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: context.res.styles.caption1
                .copyWith(fontWeight: FontWeight.w400)
                .withLineHeight(28),
          ),
        ),
      ],
    );
  }
}
