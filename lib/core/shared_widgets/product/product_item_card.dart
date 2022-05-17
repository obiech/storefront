import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/res/resources.dart';

import '../../../features/product/index.dart';
import '../buttons/pill_button.dart';

part 'out_of_stock_overdraw.dart';
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

  /// Widget Scale factor for button & text
  final double scaleFactor;

  /// Border Radius for card
  final double borderRadius;

  const ProductItemCard({
    Key? key,
    required this.product,
    this.itemQuantity = 0,
    this.scaleFactor = 1,
    this.borderRadius = 18,
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: widget.scaleFactor,
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
                widget.borderRadius,
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
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        child: Container(
                          color: res.colors.lightBlue,
                          padding: EdgeInsets.all(res.dimens.spacingMiddle),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: widget.product.thumbnailUrl,
                              fit: BoxFit.contain,
                              errorWidget: (_, __, ___) => Icon(
                                DropezyIcons.logo,
                                size: 65 * widget.scaleFactor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.product.marketStatus != null)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: widget.product.marketStatus ==
                                    MarketStatus.FLASH_SALE
                                ? ProductBadge.flash(
                                    res,
                                    scaleFactor: widget.scaleFactor,
                                  )
                                : ProductBadge.bestSeller(
                                    res,
                                    scaleFactor: widget.scaleFactor,
                                  ),
                          ),
                        ),

                      /// Stock is almost over
                      if (widget.product.isAlmostDepleted)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ProductBadge.stockWarning(
                              res,
                              widget.product.stock,
                              scaleFactor: widget.scaleFactor,
                            ),
                          ),
                        )
                    ],
                  ),
                  SizedBox(
                    height: res.dimens.spacingMedium * widget.scaleFactor,
                  ),
                  Text(
                    widget.product.price.toCurrency(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: res.styles.caption2.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: res.styles.caption2.fontSize,
                    ),
                  ),
                  if (widget.product.discount != null) ...[
                    SizedBox(
                      height: 3 * widget.scaleFactor,
                    ),
                    Text(
                      widget.product.discount!.toCurrency(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: res.styles.caption3.copyWith(
                        decoration: TextDecoration.lineThrough,
                        fontSize: res.styles.caption3.fontSize,
                      ),
                    )
                  ],
                  SizedBox(
                    height: 3 * widget.scaleFactor,
                  ),
                  Text(
                    widget.product.name.capitalize(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: res.styles.caption3.copyWith(
                      fontWeight: FontWeight.w400,
                      color: res.colors.black,
                      fontSize: res.styles.caption3.fontSize,
                    ),
                  ),
                  SizedBox(
                    height: 2 * widget.scaleFactor,
                  ),
                  //TODO(obella465): Where will unit be got
                  Text(
                    '500 g',
                    style: res.styles.caption3.copyWith(
                      color: const Color(0xFF70717D),
                      fontSize: 11,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    height: 30 * widget.scaleFactor,
                    width: double.infinity,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _qtyIsGreaterThanZero,
                      builder: (_, value, __) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                          child: value
                              ? QtyChanger(
                                  key: ValueKey(
                                    '${widget.product.id}_qty_changer',
                                  ),
                                  scaleFactor: widget.scaleFactor,
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
                                    '${widget.product.id}_add_to_cart',
                                  ),
                                  scaleFactor: widget.scaleFactor,
                                  text: widget.product.isOutOfStock
                                      ? res.strings.outOfStock
                                      : res.strings.addToCart,
                                  color: res.colors.lightBlue,
                                  textColor: res.colors.blue,
                                  onTap: !widget.product.isOutOfStock
                                      ? () {
                                          /// TODO (obella465)- Add to cart
                                          _qty = 1;
                                          _qtyIsGreaterThanZero.value = true;
                                        }
                                      : null,
                                ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          if (widget.product.isOutOfStock)
            OutOfStockOverdraw(
              borderRadius: widget.borderRadius,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _qtyIsGreaterThanZero.dispose();
    super.dispose();
  }
}
