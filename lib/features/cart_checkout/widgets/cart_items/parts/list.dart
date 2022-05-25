part of '../cart_items_section.dart';

/// A list of [ProductTile]s to represent items in the user's shopping cart.
class CartItemsList extends StatelessWidget {
  @visibleForTesting
  const CartItemsList({
    Key? key,
    required this.items,
  }) : super(key: key);

  /// Cart items to display.
  final List<CartItemModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.res.dimens.spacingMiddle,
          ),
          child: CartItemTile(item: item),
        );
      },
      separatorBuilder: (_, index) {
        return Divider(
          color: context.res.colors.dividerColor,
          height: 1,
        );
      },
      itemCount: items.length,
    );
  }
}
