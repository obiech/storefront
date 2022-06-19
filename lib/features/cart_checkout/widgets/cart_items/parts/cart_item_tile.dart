part of '../cart_items_section.dart';

/// Contains a [ProductTile] and either
///
/// - a [QtyChanger] if item is in stock,
/// - or a 'Delete Item' button if item is out of stock.
///
/// In the case that item quantity is changed to zero,
/// this widget would not be rendered
/// as the item is considered to be removed.
class CartItemTile extends StatefulWidget {
  const CartItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CartItemModel item;

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  late ValueNotifier<bool> _isAtMaxQty;

  @override
  void initState() {
    super.initState();
    _isAtMaxQty = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return ProductTile(
      variant: widget.item.variant,
      trailing: !widget.item.variant.isOutOfStock
          ? Column(
              children: [
                SizedBox(
                  height: 30,
                  width: 80,
                  child: QtyChanger(
                    key:
                        CartItemsSectionKeys.qtyChanger(widget.item.variant.id),
                    onQtyChanged: (quantity) =>
                        _editItemQty(context, widget.item.variant, quantity),
                    value: widget.item.quantity,
                    stock: widget.item.variant.stock,
                    maxValue: widget.item.variant.maxQty,
                    onMaxAvailableQtyChanged: (isAtMaxQty) async {
                      _isAtMaxQty.value = isAtMaxQty;
                    },
                  ),
                ),
                // TODO(leovinsen): refactor & merge with Variants List's version
                ValueListenableBuilder<bool>(
                  valueListenable: _isAtMaxQty,
                  builder: (_, isAtMaxQty, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isAtMaxQty
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  context.res.strings.maximumQty(
                                    widget.item.variant.maxQty ?? 0,
                                  ),
                                  style: context.res.styles.textSmall
                                      .copyWith(
                                        color: context.res.colors.red,
                                        fontSize: 8,
                                      )
                                      .withLineHeight(9.75),
                                )
                              ],
                            )
                          : const SizedBox(),
                    );
                  },
                )
              ],
            )
          : DropezyTextButton(
              key: CartItemsSectionKeys.deleteButton(widget.item.variant.id),
              label: context.res.strings.delete,
              leading: Icon(
                DropezyIcons.trash,
                size: 16,
                color: context.res.colors.blue,
              ),
              onPressed: () => _removeCartItem(context, widget.item),
            ),
    );
  }

  void _editItemQty(
    BuildContext context,
    VariantModel variant,
    int quantity,
  ) {
    context.read<CartBloc>().add(EditCartItem(variant, quantity));
  }

  void _removeCartItem(BuildContext context, CartItemModel item) {
    context.read<CartBloc>().add(RemoveCartItem(item.variant));
  }
}
