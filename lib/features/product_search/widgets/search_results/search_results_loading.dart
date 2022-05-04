import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

class SearchResultsLoading extends StatelessWidget {
  /// Number of loading columns
  final int columns;

  /// Loading card aspect ratio
  final double aspectRatio;

  /// Grid vertical spacing
  final double verticalSpacing;

  /// Grid horizontal spacing
  final double horizontalSpacing;

  /// Screen scale factor
  final double scaleFactor;

  /// Product Item card border radius
  final double borderRadius;

  const SearchResultsLoading({
    Key? key,
    required this.columns,
    required this.aspectRatio,
    required this.verticalSpacing,
    required this.horizontalSpacing,
    required this.scaleFactor,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: res.dimens.spacingLarge,
        vertical: res.dimens.spacingLarge,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: horizontalSpacing,
        mainAxisSpacing: verticalSpacing,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ProductItemCardLoading(
          scaleFactor: scaleFactor,
          borderRadius: borderRadius,
        );
      },
      shrinkWrap: true,
      itemCount: columns * 2,
    );
  }
}
