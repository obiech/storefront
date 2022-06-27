import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/domain/domain.dart';

/// The product sub-header has two curved ends at the top
/// and contains the product name, a like button and a share button
///
/// Also a product depletion warning if the product stock goes below 3 items
class ProductDetailsSubHeader extends StatelessWidget {
  /// The product whose details are to be displayed
  final ProductModel product;

  const ProductDetailsSubHeader({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      decoration: res.styles.bottomSheetStyle,
      padding: const EdgeInsets.fromLTRB(16, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: res.styles.subtitle
                      .copyWith(fontWeight: FontWeight.w500)
                      .withLineHeight(24),
                ),
              ),
              // TODO: Re-enable once wishlist feature is available
              // IconButton(
              //   onPressed: () {
              //     // TODO(obella): Add like logic for product
              //   },
              //   icon: const Icon(DropezyIcons.heart_alt),
              //   color: res.colors.black,
              // ),
              // TODO: Re-enable once share feature is available
              // IconButton(
              //   onPressed: () {
              //     // TODO(obella): Add share logic for product
              //   },
              //   icon: const Icon(DropezyIcons.share),
              //   color: res.colors.black,
              // )
            ],
          ),

          /// Stock is almost over
          if (product.isAlmostDepleted)
            ProductBadge.stockWarning(
              res,
              product.stock,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3.5,
              ),
              textStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ).withLineHeight(13),
            )
        ],
      ),
    );
  }
}
