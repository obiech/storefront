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
                  onQtyChanged: (qty) => _updateCart(context, qty),
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

  /// When [QtyChanger.onQtyChanged] is triggered,
  /// the new quantity is submitted to the backend
  /// to update the cart
  ///
  /// * [quantity] - The new quantity of this variant
  void _updateCart(
    BuildContext context,
    int quantity,
  ) {
    final variant = widget.product is ProductModel
        ? (widget.product as ProductModel).defaultVariant
        : widget.product as VariantModel;

    context.read<CartBloc>().add(EditCartItem(variant, quantity));

    _qty = quantity;
    if (_qty == 0) {
      _isInCart.value = false;
    }
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
      if (product.hasMultipleVariants) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) {
            return ProductVariantsList(product: product);
          },
        );
      } else {
        if (product.variants.isEmpty) return;
        _addVariantToCart(context, product.defaultVariant);
        _qty = 1;
        _isInCart.value = true;
      }
    } else {
      _addVariantToCart(context, widget.product as VariantModel);

      _qty = 1;
      _isInCart.value = true;
    }
  }

  Future<void> _addVariantToCart(
    BuildContext context,
    VariantModel variant,
  ) async {
    context.read<CartBloc>().add(AddCartItem(variant));
    // TODO(obella465): Handle failure & loading
    // https://dropezy.atlassian.net/browse/STOR-467
  }

  @override
  void dispose() {
    _isInCart.dispose();
    super.dispose();
  }
}
