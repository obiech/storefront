part of '../product_item_card.dart';

class CardProductAction extends StatefulWidget {
  const CardProductAction({
    Key? key,
    required this.scaleFactor,
    required this.product,
  }) : super(key: key);

  final double scaleFactor;
  final ProductModel product;

  @override
  State<CardProductAction> createState() => __CardProductActionState();
}

class __CardProductActionState extends State<CardProductAction> {
  int _productQty = 0;
  late bool isSingleVariant;

  @override
  void initState() {
    super.initState();
    isSingleVariant = !widget.product.hasMultipleVariants;

    final cartBloc = context.read<CartBloc>().state;
    if (cartBloc is CartLoaded) {
      _productQty = cartBloc.cart.productStockInCart(widget.product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (_, currState) {
        if (currState is! CartLoaded) return false;

        final productQty = currState.cart.productStockInCart(widget.product.id);

        // Only rebuild when quantity has changed
        if (productQty != _productQty) {
          _productQty = productQty;
          return true;
        }

        return false;
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (!isSingleVariant) {
              ProductCardUtils.launchVariantBottomSheet(
                context,
                widget.product,
              );
            }
          },
          child: AbsorbPointer(
            absorbing: !isSingleVariant,
            child: ProductAction(
              key: UniqueKey(),
              productQuantity: _productQty,
              product: widget.product,
              scaleFactor: widget.scaleFactor,
              isEnabled: isSingleVariant,
              onMaxAvailableQtyChanged: (isAtMaxQty) {
                // TODO(obella) - Handle for Product Card
              },
            ),
          ),
        );
      },
    );
  }
}
