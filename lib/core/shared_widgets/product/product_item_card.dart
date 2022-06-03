import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/res/resources.dart';

import '../../../features/cart_checkout/index.dart';
import '../../../features/product/index.dart';
import '../bottom_sheet/drag_handle.dart';
import '../buttons/pill_button.dart';

part 'parts/out_of_stock_overdraw.dart';
part 'parts/product_action.dart';
part 'parts/product_badge.dart';
part 'parts/product_item_card_loading.dart';
part 'parts/product_variants_list.dart';
part 'parts/qty_changer.dart';
part 'parts/variants_list_view.dart';

/// Show's a single inventory product's details including
/// * Price
/// * Discount
/// * Name
/// * Image
/// * Unit
///
/// It also displays product states like "Flash Sale" and "Best Seller"
///
/// For an item not in cart it offers a button to add the item to cart
/// and for one in the cart increment and decrement options for the cart
/// quantity.
class ProductItemCard extends StatelessWidget {
  /// Inventory product
  final ProductModel product;

  /// Current item quantity
  ///
  /// If item is in cart, pass current cart quantity
  final int itemQuantity;

  /// Widget Scale factor for button & text
  final double scaleFactor;

  /// Border Radius for card
  final double borderRadius;

  /// Callback fired when product card is tapped
  final ProductCallback? onTap;

  const ProductItemCard({
    Key? key,
    required this.product,
    this.itemQuantity = 0,
    this.scaleFactor = 1,
    this.borderRadius = 18,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return GestureDetector(
      onTap: () => onTap?.call(product),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: scaleFactor,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: res.colors.boxShadow.withOpacity(.3),
                    blurRadius: 16,
                    spreadRadius: 3,
                  ),
                ],
                borderRadius: BorderRadius.circular(
                  borderRadius,
                ),
                color: res.colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(res.dimens.spacingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        DropezyImage(
                          url: product.thumbnailUrl,
                          borderRadius: borderRadius,
                        ),
                        if (product.marketStatus != null)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: product.marketStatus ==
                                      MarketStatus.FLASH_SALE
                                  ? ProductBadge.flash(
                                      res,
                                      scaleFactor: scaleFactor,
                                    )
                                  : ProductBadge.bestSeller(
                                      res,
                                      scaleFactor: scaleFactor,
                                    ),
                            ),
                          ),

                        /// Stock is almost over
                        if (product.isAlmostDepleted)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: ProductBadge.stockWarning(
                                res,
                                product.stock,
                                scaleFactor: scaleFactor,
                              ),
                            ),
                          )
                      ],
                    ),
                    SizedBox(
                      height: res.dimens.spacingMedium * scaleFactor,
                    ),
                    Text(
                      product.price.toCurrency(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: res.styles.caption2.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: res.styles.caption2.fontSize,
                      ),
                    ),
                    if (product.discount != null) ...[
                      SizedBox(
                        height: 3 * scaleFactor,
                      ),
                      Text(
                        product.discount!.toCurrency(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: res.styles.discountText,
                      )
                    ],
                    SizedBox(
                      height: 3 * scaleFactor,
                    ),
                    Text(
                      product.name.capitalize(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: res.styles.caption3.copyWith(
                        fontWeight: FontWeight.w400,
                        color: res.colors.black,
                        fontSize: res.styles.caption3.fontSize,
                      ),
                    ),
                    SizedBox(
                      height: 2 * scaleFactor,
                    ),
                    Text(
                      product.unit,
                      style: res.styles.caption3.copyWith(
                        color: const Color(0xFF70717D),
                        fontSize: 11,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      height: 30 * scaleFactor,
                      width: double.infinity,
                      child: ProductAction(
                        productQuantity: itemQuantity,
                        product: product,
                        scaleFactor: scaleFactor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (product.isOutOfStock)
              OutOfStockOverdraw(
                borderRadius: borderRadius,
              ),
          ],
        ),
      ),
    );
  }
}
