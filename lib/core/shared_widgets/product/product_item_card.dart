import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/domain/models/market_status.dart';
import 'package:storefront_app/features/product/domain/models/product_model.dart';
import 'package:storefront_app/res/resources.dart';

import '../buttons/pill_button.dart';

part 'product_badge.dart';
part 'qty_changer.dart';

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

  /// If item is in cart
  final bool isInCart;

  /// Current item quantity
  ///
  /// If item is in cart, pass current cart quantity
  final int itemQuantity;

  const ProductItemCard({
    Key? key,
    required this.product,
    this.isInCart = false,
    this.itemQuantity = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: res.colors.boxShadow.withOpacity(.3),
            blurRadius: 16,
            spreadRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(res.dimens.spacingLarge),
        color: res.colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(res.dimens.spacingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(res.dimens.spacingLarge),
                  child: Container(
                    color: res.colors.lightBlue,
                    padding: EdgeInsets.all(res.dimens.spacingMiddle),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: product.thumbnailUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                if (product.marketStatus != null)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: product.marketStatus == MarketStatus.FLASH_SALE
                          ? ProductBadge.flash(res)
                          : ProductBadge.bestSeller(res),
                    ),
                  )
              ],
            ),
            SizedBox(
              height: res.dimens.spacingMedium,
            ),
            Text(
              product.price.toCurrency(),
              style: res.styles.caption2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (product.discount != null) ...[
              const SizedBox(
                height: 3,
              ),
              Text(
                product.discount!.toCurrency(),
                style: res.styles.caption3.copyWith(
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                ),
              )
            ],
            const SizedBox(
              height: 3,
            ),
            Text(
              product.name,
              style: res.styles.caption3.copyWith(
                fontWeight: FontWeight.w400,
                color: res.colors.black,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            //TODO(obella465): Where will unit be got
            Text(
              '500 g',
              style: res.styles.caption3.copyWith(
                fontWeight: FontWeight.w400,
                color: const Color(0xFF70717D),
                fontSize: res.dimens.spacingMedium + 1,
              ),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: isInCart
                  ? QtyChanger(
                      onQtyChanged: (qty) {
                        /// TODO(obella465) - Update cart quantity
                      },
                      value: itemQuantity,
                      maxValue: product.stock,
                    )
                  : PillButton(
                      text: res.strings.addToCart,
                      color: res.colors.lightBlue,
                      textColor: res.colors.blue,
                      onTap: () {
                        /// TODO (obella465)- Add to cart
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
