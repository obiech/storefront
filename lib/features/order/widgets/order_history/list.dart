import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../../res/resources.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_product_model.dart';
import '../../utils/order_products_summarizer.dart';
import '../../widgets/order_status_chip.dart';

part 'parts/keys.dart';
part 'parts/list_item.dart';
part 'parts/order_summary_section.dart';
part 'parts/timing_text.dart';

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
      padding: EdgeInsets.only(
        top: context.res.dimens.spacingLarge,
        left: context.res.dimens.spacingLarge,
        right: context.res.dimens.spacingLarge,
        bottom: context.res.dimens.spacingLarge +
            context.res.dimens.minOffsetForCartSummary,
      ),
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(
        height: context.res.dimens.spacingMiddle,
      ),
      itemBuilder: (_, index) => GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () {
          context.router.push(
            OrderDetailsRoute(order: orders[index]),
          );
        },
        child: OrderHistoryListItem(
          key: ValueKey(OrderHistoryListKeys.listItem(index)),
          order: orders[index],
        ),
      ),
    );
  }
}
