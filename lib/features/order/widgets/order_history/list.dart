import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_product_model.dart';
import '../../utils/order_products_summarizer.dart';
import '../../widgets/order_status_chip.dart';

part 'parts/keys.dart';
part 'parts/list_item.dart';
part 'parts/order_status_timings.dart';
part 'parts/order_summary_section.dart';

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
