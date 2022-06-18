import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../../core/core.dart';
import '../../../../../res/resources.dart';
import '../../../domain/models/order_model.dart';
import '../../order_status_chip.dart';

part 'parts/bar.dart';
part 'parts/caption.dart';
part 'parts/delivery_progress_bar.dart';
part 'parts/delivery_status_indicator.dart';
part 'parts/delivery_time_remaining.dart';
part 'parts/skeleton.dart';

class OrderStatusHeader extends StatelessWidget {
  const OrderStatusHeader({
    Key? key,
    required this.orderId,
    required this.orderCreationTime,
    required this.orderStatus,
    this.estimatedArrivalTime,
    this.currentTime,
    required this.paymentCompletedTime,
    required this.pickupTime,
    required this.orderCompletedTime,
  }) : super(key: key);

  final String orderId;

  /// Date & Time when order was first created by user
  final DateTime orderCreationTime;

  final OrderStatus orderStatus;

  /// defaults to [DateTime.now].
  /// Provides a way to mock the time during tests.
  final DateTime? currentTime;

  /// Estimated order arrival time
  final DateTime? estimatedArrivalTime;

  final DateTime? paymentCompletedTime;

  final DateTime? pickupTime;

  final DateTime? orderCompletedTime;

  /// Display [DeliveryTimeRemaining] for the following statuses
  bool get showTimeRemaining => [
        OrderStatus.paid,
        OrderStatus.inDelivery,
      ].contains(orderStatus);

  bool get showProgressBar => [
        OrderStatus.paid,
        OrderStatus.inDelivery,
        OrderStatus.arrived,
      ].contains(orderStatus);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM y, HH:mm');

    return Padding(
      padding: EdgeInsets.all(context.res.dimens.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.res.strings.orderStatus,
                style: context.res.styles.subtitle,
              ),
              OrderStatusChip(orderStatus: orderStatus),
            ],
          ),
          SizedBox(height: context.res.dimens.spacingLarge),
          if (showTimeRemaining) ...[
            DeliveryTimeRemaining(
              timeInSeconds: estimatedArrivalTime!
                  .difference(currentTime ?? DateTime.now())
                  .inSeconds,
            ),
            SizedBox(height: context.res.dimens.spacingLarge),
          ],
          if (showProgressBar) ...[
            DeliveryProgressBar(
              orderStatus: orderStatus,
              paymentCompletedTime: paymentCompletedTime,
              pickupTime: pickupTime,
              orderCompletedTime: orderCompletedTime,
            ),
            SizedBox(height: context.res.dimens.spacingMiddle),
            OrderStatusCaption(orderStatus: orderStatus),
          ],
          SizedBox(height: context.res.dimens.spacingMiddle),
          _TextRow(
            label: 'Order ID',
            value: orderId,
          ),
          SizedBox(height: context.res.dimens.spacingSmall),
          _TextRow(
            label: context.res.strings.orderTime,
            value: dateFormat.format(orderCreationTime),
          ),
        ],
      ),
    );
  }
}

class _TextRow extends StatelessWidget {
  const _TextRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.res.styles.caption2.copyWith(
            fontWeight: FontWeight.w500,
            height: 20 / 12,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: context.res.styles.caption2.copyWith(
                fontWeight: FontWeight.w600,
                height: 20 / 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
