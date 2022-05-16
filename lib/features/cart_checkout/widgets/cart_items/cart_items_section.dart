import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../../product/widgets/product_tile/product_tile.dart';
import '../../domain/domains.dart';

part 'parts/list.dart';
part 'parts/list_loading.dart';

/// Section starts from the text 'Cart' at the top
/// and consists of the following widgets:
///
/// - list of cart items [CartItemsList]
/// - voucher selection (to be implemented)
/// - use Dropezy points toggle (to be implemented)
class CartItemsSection extends StatelessWidget {
  const CartItemsSection({
    Key? key,
    required this.items,
  }) : super(key: key);

  /// User's items in the cart
  final List<CartItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.res.dimens.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.res.strings.cart,
            style: context.res.styles.caption1.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Divider(
            height: 1,
            color: context.res.colors.dividerColor,
          ),
          CartItemsList(items: items),
          Divider(
            height: 1,
            color: context.res.colors.dividerColor,
          ),
        ],
      ),
    );
  }
}
