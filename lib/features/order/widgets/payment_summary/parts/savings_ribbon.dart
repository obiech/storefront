part of '../order_payment_summary.dart';

/// Ribbon-like widget that displays amount saved by user in
/// this order.
class _SavingsRibbon extends StatelessWidget {
  const _SavingsRibbon({
    Key? key,
    required this.totalSavings,
  }) : super(key: key);

  final String totalSavings;

  @override
  Widget build(BuildContext context) {
    return SemiCircleClippedWidget(
      child: Container(
        height: 40,
        color: context.res.colors.savingsRibbonGreen,
        alignment: Alignment.center,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${context.res.strings.wowYouManagedToSave} ',
                style: context.res.styles.caption2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: totalSavings.toCurrency(),
                style: context.res.styles.caption2.copyWith(
                  color: context.res.colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' !',
                style: context.res.styles.caption2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
