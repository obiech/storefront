part of '../product_tile.dart';

/// Skeleton loader for [ProductTile] that consists of:
///
/// - an image skeleton (left side)
/// - a [SkeletonParagraph] in the remaining space
class ProductTileSkeleton extends StatelessWidget {
  const ProductTileSkeleton({
    Key? key,
    this.imageSize = 60.0,
    this.imageBorderRadius = 8.0,
    this.numOfLines = 4,
  }) : super(key: key);

  /// width and height of the image silhouette
  final double imageSize;

  /// border radius of image silhouette
  final double imageBorderRadius;

  /// number of skeleton lines to show
  final int numOfLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: imageSize,
                  height: imageSize,
                  borderRadius: BorderRadius.circular(8.0),
                  padding: EdgeInsets.all(context.res.dimens.spacingMiddle),
                ),
              ),
              Expanded(
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: numOfLines,
                    spacing: 4,
                    lineStyle: SkeletonLineStyle(
                      height: 9,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
