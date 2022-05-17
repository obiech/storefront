import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'parts/discount_tag.dart';
part 'parts/product_information.dart';
part 'parts/skeleton.dart';

/// Widget for displaying product variant information such as:
/// - Product Image (left side)
/// - Product information such as price, discount,
/// and unit of measurement (middle)
/// - Optional [trailing] Widget. (right side)
///
/// This Widget is used in Cart Page and in Product Item Card.
///
/// Design wise is similar to a [ListTile].

// TODO: Update to use new Product Base model
class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key,
    required this.product,
    this.trailing,
    this.imageSize = 60,
  }) : super(key: key);

  /// Product information.
  final ProductModel product;

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
          child: Row(
            children: [
              SizedBox(
                width: imageSize,
                height: imageSize,
                child: DropezyImage(
                  url: product.thumbnailUrl,
                  borderRadius: 8,
                ),
              ),
              const SizedBox(width: 8),
              ProductInformation(product: product),
            ],
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
