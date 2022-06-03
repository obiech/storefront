part of '../list.dart';

class TimingText extends StatelessWidget {
  const TimingText({
    Key? key,
    this.title,
    required this.timeLabel,
    required this.color,
    this.iconData,
  }) : super(key: key);

  /// For [OrderStatus.awaitingPayment]
  factory TimingText.awaitingPayment({
    required Resources res,
    required int remainingTimeInSeconds,
  }) {
    return TimingText(
      title: res.strings.completePaymentWithin,
      timeLabel: Duration(seconds: remainingTimeInSeconds).toHhMmSs(),
      color: res.colors.orange,
      iconData: DropezyIcons.time,
    );
  }

  /// For [OrderStatus.paid] and [OrderStatus.inDelivery]
  factory TimingText.inProgress({
    required Resources res,
    required int remainingTimeInSeconds,
  }) {
    return TimingText(
      title: res.strings.estimatedArrivalTime,
      timeLabel: Duration(seconds: remainingTimeInSeconds).toMmSs(),
      color: res.colors.lightGreen,
      iconData: DropezyIcons.pin,
    );
  }

  /// For [OrderStatus.arrived]
  factory TimingText.arrived({
    required Resources res,
    required DateTime orderCompletionTime,
  }) {
    final dateFormat = DateFormat('d MMM y • HH:mm');
    return TimingText(
      title: res.strings.orderArrivedAt,
      timeLabel: dateFormat.format(orderCompletionTime),
      color: res.colors.black,
    );
  }

  /// Text shown above [timeLabel]
  final String? title;

  /// Contains time-related info such as order date
  /// or remaining time before payment expiry
  final String timeLabel;

  /// Color used for [title], [timeLabel] and icon (if any)
  final Color color;

  /// Icon to be shown to the left of [timeLabel]
  /// Will not be shown if [null]
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: Text(
            title ?? '',
            style: context.res.styles.caption3.copyWith(
              color: context.res.colors.grey5,
              height: 1.6, // 10 x 1.6 = 16dp
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null) ...[
              Icon(
                iconData,
                color: color,
                size: 16,
              ),
              SizedBox(width: context.res.dimens.spacingMedium),
            ],
            Text(
              timeLabel,
              style: context.res.styles.caption2.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
            )
          ],
        )
      ],
    );
  }
}
