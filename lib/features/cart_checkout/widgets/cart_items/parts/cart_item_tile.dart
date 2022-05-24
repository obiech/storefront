part of '../cart_items_section.dart';

/// Contains a [ProductTile] and either
///
/// - a [QtyChanger] if item is in stock,
/// - or a 'Delete Item' button if item is out of stock.
///
/// In the case that item quantity is changed to zero,
/// this widget would not be rendered
/// as the item is considered to be removed.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return ProductTile(
      variant: item.variant,
      trailing: !item.variant.isOutOfStock
          ? SizedBox(
              height: 30,
              width: 80,
              child: QtyChanger(
                key: CartItemsSectionKeys.qtyChanger(item.variant.id),
                onQtyChanged: (quantity) =>
                    _editItemQty(context, item.variant, quantity),
                value: item.quantity,
                maxValue: item.variant.stock,
              ),
            )
          : DropezyTextButton(
              key: CartItemsSectionKeys.deleteButton(item.variant.id),
              label: context.res.strings.delete,
              leading: Icon(
                DropezyIcons.trash,
                size: 16,
                color: context.res.colors.blue,
              ),
              onPressed: () => _removeCartItem(context, item),
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
