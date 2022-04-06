part of '../list.dart';

/// Timings for Payment Expiry, Estimated Arrival Time,
/// and Order Completion Date & Time
class OrderStatusTimings extends StatefulWidget {
  const OrderStatusTimings({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  State<OrderStatusTimings> createState() => _OrderStatusTimingsState();
}

class _OrderStatusTimingsState extends State<OrderStatusTimings> {
  late DateTime referenceDate;
  Timer? timer;

  bool get shouldEnableCountdown => [
        OrderStatus.awaitingPayment,
        OrderStatus.paid,
        OrderStatus.inDelivery,
      ].contains(widget.order.status);

  @override
  void initState() {
    super.initState();
    if (shouldEnableCountdown) {
      switch (widget.order.status) {
        case OrderStatus.awaitingPayment:
          referenceDate = widget.order.paymentExpiryTime!;
          break;
        case OrderStatus.paid:
        case OrderStatus.inDelivery:
          referenceDate = widget.order.estimatedArrivalTime!;
          break;
        default:
          return;
      }
      // Rebuild UI every 1 seconds for countdown
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (referenceDate.isBefore(DateTime.now())) {
            timer.cancel();
            this.timer = null;
          }
          setState(() {});
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // TODO (leovinsen): Figure a way to write this more elegantly
  @override
  Widget build(BuildContext context) {
    late String label;
    late Color dateColor;
    late IconData? iconData;
    late String timingLabel;

    switch (widget.order.status) {
      case OrderStatus.awaitingPayment:
        label = context.res.strings.completePaymentWithin;
        timingLabel = widget.order.paymentExpiryTime!.getPrettyTimeDifference(
          TimeDiffFormat.hhmmss,
          DateTime.now(),
        );
        dateColor = context.res.colors.orange;
        iconData = DropezyIcons.time;
        break;
      case OrderStatus.paid:
      case OrderStatus.inDelivery:
        label = context.res.strings.estimatedArrivalTime;
        timingLabel =
            widget.order.estimatedArrivalTime!.getPrettyTimeDifference(
          TimeDiffFormat.mmss,
          DateTime.now(),
        );
        dateColor = context.res.colors.green;
        iconData = DropezyIcons.pin;
        break;
      case OrderStatus.arrived:
        label = context.res.strings.orderArrivedAt;
        final dateFormat = DateFormat('d MMM y • HH:mm');
        timingLabel = dateFormat.format(widget.order.orderCompletionTime!);
        dateColor = context.res.colors.black;
        iconData = null;
        break;
      default:
        return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.res.styles.caption3.copyWith(
            color: context.res.colors.grey5,
            height: 1.6, // 10 x 1.6 = 16dp
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (iconData != null)
              Padding(
                padding: EdgeInsets.only(
                  right: context.res.dimens.spacingMedium,
                ),
                child: Icon(
                  DropezyIcons.time,
                  color: dateColor,
                  size: 13.33,
                ),
              ),
            Text(
              timingLabel,
              style: context.res.styles.caption2.copyWith(
                fontWeight: FontWeight.w500,
                color: dateColor,
              ),
            )
          ],
        )
      ],
    );
  }
}
