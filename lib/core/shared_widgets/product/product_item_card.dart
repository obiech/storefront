import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/res/resources.dart';

import '../../../features/product/index.dart';
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
class ProductItemCard extends StatefulWidget {
  /// Inventory product
  final ProductModel product;

  /// Current item quantity
  ///
  /// If item is in cart, pass current cart quantity
  final int itemQuantity;

  const ProductItemCard({
    Key? key,
    required this.product,
    this.itemQuantity = 0,
  }) : super(key: key);

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {
  // Add to cart / Quantity Changer State
  late ValueNotifier<bool> _qtyIsGreaterThanZero;

  // Item Quantity
  int _qty = 0;

  @override
  void initState() {
    _qtyIsGreaterThanZero = ValueNotifier(widget.itemQuantity > 0);
    _qty = widget.itemQuantity;
    super.initState();
  }

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
                        imageUrl: widget.product.thumbnailUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                if (widget.product.marketStatus != null)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child:
                          widget.product.marketStatus == MarketStatus.FLASH_SALE
                              ? ProductBadge.flash(res)
                              : ProductBadge.bestSeller(res),
                    ),
                  ),
                if (widget.product.stock <= 3)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child:
                          ProductBadge.stockWarning(res, widget.product.stock),
                    ),
                  )
              ],
            ),
            SizedBox(
              height: res.dimens.spacingMedium,
            ),
            Text(
              widget.product.price.toCurrency(),
              style: res.styles.caption2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.product.discount != null) ...[
              const SizedBox(
                height: 3,
              ),
              Text(
                widget.product.discount!.toCurrency(),
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
              widget.product.name,
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
              child: ValueListenableBuilder<bool>(
                valueListenable: _qtyIsGreaterThanZero,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: value
                        ? QtyChanger(
                            key: ValueKey(
                              '${widget.product.productId}_qty_changer',
                            ),
                            onQtyChanged: (qty) {
                              /// TODO(obella465) - Update cart quantity
                              _qty = qty;
                              if (_qty == 0) {
                                _qtyIsGreaterThanZero.value = false;
                              }
                            },
                            value: _qty,
                            maxValue: widget.product.stock,
                          )
                        : PillButton(
                            key: ValueKey(
                              '${widget.product.productId}_add_to_cart',
                            ),
                            text: res.strings.addToCart,
                            color: res.colors.lightBlue,
                            textColor: res.colors.blue,
                            onTap: () {
                              /// TODO (obella465)- Add to cart
                              _qty = 1;
                              _qtyIsGreaterThanZero.value = true;
                            },
                          ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _qtyIsGreaterThanZero.dispose();
    super.dispose();
  }
}
