part of '../list.dart';

extension OrderStatusX on OrderStatus {
  bool get isAwaitingPayment => this == OrderStatus.awaitingPayment;
  bool get isInProgress => [
        OrderStatus.paid,
        OrderStatus.inDelivery,
      ].contains(this);
  bool get isArrived => this == OrderStatus.arrived;
}

/// Widget for itemBuilder in [OrderHistoryList]
///
/// Is a card-shaped Container that displays information of an [OrderModel]
/// such as:
/// - Remaining expiry time / delivery time
/// - Current order status
/// - Order thumbnail
/// - Order products summary
/// - Amount paid
class OrderHistoryListItem extends StatelessWidget {
  const OrderHistoryListItem({
    Key? key,
    required this.order,
    this.currentTime,
    this.launchGoPay = const LaunchGoPay(),
  }) : super(key: key);

  final OrderModel order;

  /// Used for mocking current time in tests
  final DateTime? currentTime;

  // Gojek link launcher
  final LaunchGoPay launchGoPay;

  @override
  Widget build(BuildContext context) {
    final cardPadding = context.res.dimens.spacingMiddle;
    final topMargin = context.res.dimens.spacingMedium;

    final boxShadow = BoxShadow(
      color: const Color(0xFF000000)
          .withAlpha((13 / 100 * 255).ceil()), //13% opacity
      blurRadius: 13,
      offset: const Offset(0, 3),
    );

    return Container(
      padding: EdgeInsets.only(
        left: cardPadding,
        right: cardPadding,
        top: topMargin, // to account for Text line height
        bottom: cardPadding,
      ),
      decoration: BoxDecoration(
        color: context.res.colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [boxShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (order.status.isArrived)
                TimingText.arrived(
                  res: context.res,
                  orderCompletionTime: order.orderCompletionTime!,
                ),
              if (order.status.isAwaitingPayment)
                CountdownBuilder(
                  countdownDuration: order.paymentExpiryTime
                      .difference(currentTime ?? DateTime.now())
                      .inSeconds,
                  builder: (seconds) {
                    return TimingText.awaitingPayment(
                      res: context.res,
                      remainingTimeInSeconds: seconds,
                    );
                  },
                ),
              if (order.status.isInProgress)
                CountdownBuilder(
                  countdownDuration: order.estimatedArrivalTime!
                      .difference(currentTime ?? DateTime.now())
                      .inSeconds,
                  builder: (seconds) {
                    return TimingText.inProgress(
                      res: context.res,
                      remainingTimeInSeconds: seconds,
                    );
                  },
                ),
              const Spacer(),
              OrderStatusChip(orderStatus: order.status),
            ],
          ),
          Divider(
            // margin of 12 dp on both vertical sides
            height: context.res.dimens.spacingMedium * 2,
            color: context.res.colors.dividerColor,
          ),
          OrderSummarySection(order: order),
          if (order.status.isAwaitingPayment) ...[
            SizedBox(height: context.res.dimens.spacingMedium),
            DropezyButton.primary(
              label: context.res.strings.continuePayment,
              onPressed: () {
                // context.pushRoute(PaymentInstructionsRoute(order: order));
                PayNow(
                  order: order,
                  context: context,
                  launchGoPay: launchGoPay,
                );
                // TODO(obella) : for Deeplink Payment
              },
              padding: EdgeInsets.symmetric(
                horizontal: context.res.dimens.spacingLarge,
                vertical: 2,
              ),
              textStyle: context.res.styles.caption2.copyWith(
                fontWeight: FontWeight.w600,
                color: context.res.colors.white,
                height: 1.2, // 12 x 1.2 = 14
              ),
            ),
          ]
        ],
      ),
    );
  }
}
