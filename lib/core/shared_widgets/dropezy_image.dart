import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core.dart';

/// Image with a default [Colors.transparent] background
/// that displays a Dropezy 'D' logo when image fails to load.
///
/// To size this widget, wrap it with a [SizedBox]:
///
/// ```dart
/// SizedBox(
///   width: 100,
///   height: 100,
///   child: DropezyImage(
///     url: 'image-url',
///   ),
/// )
/// ```
///
/// Uses [CachedNetworkImage] as underlying Image widget.
///
/// To set a background, you can set the
/// [DropezyImage.color] value to a [Color] value.
class DropezyImage extends StatelessWidget {
  const DropezyImage({
    Key? key,
    required this.url,
    this.padding,
    this.borderRadius,
    this.color = Colors.transparent,
  }) : super(key: key);

  /// URL to the image.
  /// Has to be a .png file with transparent background.
  final String url;

  /// Padding between image and the blue background
  final EdgeInsets? padding;

  /// Border radius of the image background
  final double? borderRadius;

  /// Image background
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          child: Container(
            color: color,
            padding:
                padding ?? EdgeInsets.all(context.res.dimens.spacingMiddle),
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => Icon(
                  DropezyIcons.logo,
                  size: constraints.maxWidth * 0.6,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
