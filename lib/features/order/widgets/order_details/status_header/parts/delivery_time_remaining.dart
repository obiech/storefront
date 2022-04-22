part of '../widget.dart';

/// Displays time remaining before Estimated Delivery Time is reached
/// in the form of a countdown, and a circular progress bar
class DeliveryTimeRemaining extends StatelessWidget {
  const DeliveryTimeRemaining({
    Key? key,
    required this.timeInSeconds,
  }) : super(key: key);

  final int timeInSeconds;

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return CountdownBuilder(
      countdownDuration: timeInSeconds,
      builder: (timeLeftInSeconds) {
        // TODO (leovinsen): Might be a dynamic value in the future
        const deliveryGuarantee = 15 * 60;

        final percentRemaining =
            (timeLeftInSeconds / deliveryGuarantee).clamp(0.0, 1.0);
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
      },
    );
  }
}
