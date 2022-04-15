part of '../widget.dart';

/// Displays time remaining before Estimated Delivery Time is reached
/// in the form of a countdown, and a circular progress bar
class DeliveryTimeRemaining extends StatefulWidget {
  const DeliveryTimeRemaining({
    Key? key,
    required this.timeInSeconds,
  }) : super(key: key);

  final int timeInSeconds;

  @override
  State<DeliveryTimeRemaining> createState() => _DeliveryTimeRemainingState();
}

class _DeliveryTimeRemainingState extends State<DeliveryTimeRemaining> {
  late int timeLeftInSeconds;
  late Timer? timer;

  /// relative to 15 mins delivery guarantee
  double get percentRemaining =>
      (timeLeftInSeconds / (15 * 60)).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    timeLeftInSeconds = widget.timeInSeconds;

    // Rebuild UI every 1 seconds for countdown
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timeLeftInSeconds == 0) {
          timer.cancel();
          this.timer = null;
          return;
        }

        timeLeftInSeconds--;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return CircularPercentIndicator(
      radius: 40,
      lineWidth: 6,
      animation: true,
      animateFromLastPercent: true,
      percent: percentRemaining,
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            res.strings.estimation,
            style: res.styles.textSmall.copyWith(
              color: const Color(0xFF666666),
            ),
          ),
          Text(
            Duration(seconds: timeLeftInSeconds).toMmSs(),
            style: context.res.styles.subtitle,
          ),
        ],
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: res.colors.black,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
