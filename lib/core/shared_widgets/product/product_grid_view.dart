import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../../features/product/index.dart';

/// Grid view widget for Product card
/// whenever the state is needed to show
/// the list of product
class ProductGridView extends StatelessWidget {
  const ProductGridView({
    Key? key,
    required this.columns,
    this.aspectRatio = 13 / 25,
    this.verticalSpacing = 12,
    this.horizontalSpacing = 12,
    this.scaleFactor = 1,
    this.cardBorderRadius = 25,
    required this.productModelList,
    this.shrinkWrap,
    this.padding,
    this.physics,
    this.controller,
  }) : super(key: key);

  /// Number of loading columns
  final int columns;

  /// Product card grid aspect ratio
  final double aspectRatio;

  /// Grid horizontal spacing
  final double horizontalSpacing;

  /// Grid vertical spacing
  final double verticalSpacing;

  /// Product Item card border radius
  final double cardBorderRadius;

  /// Page scale factor
  final double scaleFactor;

  final List<ProductModel> productModelList;

  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? EdgeInsets.all(context.res.dimens.spacingMedium),
      physics: physics ?? const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: horizontalSpacing,
        mainAxisSpacing: verticalSpacing,
      ),
      itemBuilder: (BuildContext context, int index) {
        final productModel = productModelList[index];

        if (productModel.status != ProductStatus.LOADING) {
          return ProductItemCard(
            key: ValueKey('product_item$index'),
            product: productModel,
            scaleFactor: scaleFactor,
            borderRadius: cardBorderRadius,
            onTap: (product) {
              context.router.push(ProductDetailRoute(productModel: product));
            },
          );
        } else {
          return ProductItemCardLoading(borderRadius: cardBorderRadius);
        }
      },
      shrinkWrap: shrinkWrap ?? false,
      itemCount: productModelList.length,
      controller: controller,
    );
  }
}
