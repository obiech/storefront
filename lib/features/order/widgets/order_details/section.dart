import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../../../res/resources.dart';
import '../../domain/models/order_product_model.dart';

part 'parts/products_list.dart';

/// Section with heading 'Order Details' and consists of list of
/// purchased products.
///
/// TODO (leovinsen): add delivery address information
class OrderDetailsSection extends StatelessWidget {
  const OrderDetailsSection({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<OrderProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.res.dimens.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.res.strings.orderDetails,
            style: context.res.styles.subtitle,
          ),
          SizedBox(height: context.res.dimens.spacingMiddle),
          Text(
            context.res.strings.yourPurchases,
            style: context.res.styles.caption1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.res.dimens.spacingMiddle),
          ProductsList(products: products),
        ],
      ),
    );
  }
}
