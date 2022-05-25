import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../../product/domain/domain.dart';
import '../../../product/widgets/product_tile/product_tile.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../domain/domains.dart';

part 'parts/cart_item_tile.dart';
part 'parts/keys.dart';
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
    required this.title,
    required this.items,
  }) : super(key: key);

  /// Title to show above list of cart items
  final String title;

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
            title,
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
