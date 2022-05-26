import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// Show the skeleton of product card
/// whenever the state is still in loading
class ProductGridLoading extends StatelessWidget {
  /// Number of loading columns
  final int columns;

  /// Loading card aspect ratio
  final double aspectRatio;

  /// Grid vertical spacing
  final double verticalSpacing;

  /// Grid horizontal spacing
  final double horizontalSpacing;

  /// Page scale factor
  final double scaleFactor;

  /// Product Item card border radius
  final double borderRadius;

  /// Product Item card maximum row
  final int rows;

  final EdgeInsets? padding;

  final bool shrinkWrap;

  const ProductGridLoading({
    Key? key,
    required this.columns,
    this.aspectRatio = 13 / 25,
    this.verticalSpacing = 12,
    this.horizontalSpacing = 12,
    this.scaleFactor = 1,
    this.borderRadius = 25,
    required this.rows,
    this.padding,
    this.shrinkWrap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      padding: padding ??
          EdgeInsets.symmetric(
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
      shrinkWrap: shrinkWrap,
      itemCount: columns * rows,
    );
  }
}
