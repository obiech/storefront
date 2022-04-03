import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/build_context.ext.dart';
import '../../../../core/utils/string.ext.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_product_model.dart';
import '../../utils/order_products_summarizer.dart';
import '../../widgets/order_status_chip.dart';

part 'keys.dart';
part 'list_item.dart';
part 'order_summary_section.dart';

/// Displays a list of user's order history
class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({
    Key? key,
    required this.orders,
  }) : super(key: key);

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(
        height: context.res.dimens.spacingMiddle,
      ),
      itemBuilder: (_, index) => OrderHistoryListItem(
        key: ValueKey(OrderHistoryListKeys.listItem(index)),
        order: orders[index],
      ),
    );
  }
}
