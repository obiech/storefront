part of '../product_item_card.dart';

/// Widget to carry out product actions such as:-
///
/// * Change quantity
/// * Add to cart
/// * Show out of stock status
class ProductAction extends StatefulWidget {
  final double scaleFactor;
  final int productQuantity;
  final BaseProduct product;

  const ProductAction({
    Key? key,
    this.scaleFactor = 1,
    this.productQuantity = 0,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductAction> createState() => _ProductActionState();
}

class _ProductActionState extends State<ProductAction> {
  late Resources res;

  // Add to cart / Quantity Changer State
  late ValueNotifier<bool> _isInCart;

  // Item Quantity
  int _qty = 0;

  @override
  void initState() {
    res = context.res;
    _isInCart = ValueNotifier(widget.productQuantity > 0);
    _qty = widget.productQuantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isInCart,
      builder: (_, isInCart, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: isInCart
              ? QtyChanger(
                  key: ValueKey(
                    '${widget.product.id}_qty_changer',
                  ),
                  scaleFactor: widget.scaleFactor,
                  onQtyChanged: (qty) {
                    /// TODO(obella465) - Update variant cart quantity
                    _qty = qty;
                    if (_qty == 0) {
                      _isInCart.value = false;
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
                  onTap: !widget.product.isOutOfStock ? _addToCart : null,
                ),
        );
      },
    );
  }

  /// Add to cart button tap handler,
  /// behaves differently depending on number of variants a product has
  ///
  /// * If it's a [ProductModel] then check how many variants it has :-
  ///       - If it has one variant, then add it to cart.
  ///       - If it has more than one, then open the variants list bottom sheet.
  ///  * If it's a [VariantModel] then add it to cart directly
  void _addToCart() {
    if (widget.product is ProductModel) {
      final product = widget.product as ProductModel;
      if (product.variants.length > 1) {
        /// TODO - Open Variants Bottomsheet dialog
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) {
            return ProductVariantsList(product: product);
          },
        );
      } else {
        /// TODO - Add product to cart with default variant
        if (product.variants.isEmpty) return;
        _addVariantToCart(product.variants.first);
        _qty = 1;
        _isInCart.value = true;
      }
    } else {
      /// TODO - Add Variant to cart
      _addVariantToCart(widget.product as VariantModel);
      _qty = 1;
      _isInCart.value = true;
    }
  }

  Future<void> _addVariantToCart(VariantModel variant) async {
    /// TODO (obella465)- Add to cart
    /// @leovinsen we could think through how to handle a network failed
    /// add to cart
  }

  @override
  void dispose() {
    _isInCart.dispose();
    super.dispose();
  }
}
