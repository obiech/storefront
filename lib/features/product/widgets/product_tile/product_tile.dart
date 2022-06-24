import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'parts/product_information.dart';
part 'parts/skeleton.dart';

/// Widget for displaying product variant information such as:
/// - Variant Image (left side)
/// - Variant information such as price, discount,
/// and unit of measurement (middle)
/// - Optional [trailing] Widget. (right side)
///
/// When product variant is out of stock,
/// left and middle section will have an opacity of 50%.
///
/// This Widget is used in Cart Page and in Product Item Card.
///
/// Design wise is similar to a [ListTile].

//TODO (2022-06-19): if design diverges further from search's variant list
// delete this classs and move contents into CartItemTile

class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key,
    required this.variant,
    this.trailing,
    this.imageSize = 60,
  }) : super(key: key);

  /// Product variant information.
  final VariantModel variant;

  /// An optional widget at the end. For example:
  /// - Add to Cart button
  /// - Qty changer
  /// - Out of Stock indicator
  final Widget? trailing;

  /// Size of the product image.
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Opacity(
            opacity: !variant.isOutOfStock ? 1 : 0.5,
            child: Row(
              children: [
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: DropezyImage(
                    padding: EdgeInsets.zero,
                    url: variant.thumbnailUrl,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: ProductInformation(variant: variant)),
              ],
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 16),
          trailing!,
        ]
      ],
    );
  }
}
