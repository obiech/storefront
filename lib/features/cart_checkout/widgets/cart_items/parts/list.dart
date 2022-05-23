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
          child: ProductTile(
            variant: item.variant,
            trailing: !item.variant.isOutOfStock
                ? SizedBox(
                    height: 30,
                    width: 80,
                    child: QtyChanger(
                      onQtyChanged: (qty) {
                        //TODO(leovinsen): connect with CartBloc edit item qty
                        // https://dropezy.atlassian.net/browse/STOR-60
                      },
                      value: items[index].quantity,
                      maxValue: items[index].variant.stock,
                    ),
                  )
                : DropezyTextButton(
                    label: context.res.strings.delete,
                    leading: Icon(
                      DropezyIcons.trash,
                      size: 16,
                      color: context.res.colors.blue,
                    ),
                    onPressed: () {
                      //TODO(leovinsen): connect with CartBloc delete item
                      // https://dropezy.atlassian.net/browse/STOR-468
                    },
                  ),
          ),
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
