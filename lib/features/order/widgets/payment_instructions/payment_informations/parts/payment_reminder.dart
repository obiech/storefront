part of '../payment_information_section.dart';

/// Widget for rounded container with content explaining
/// that order will be processed after verifying payment
class PaymentReminderContainer extends StatelessWidget {
  const PaymentReminderContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        color: context.res.colors.lightOrange,
      ),
      child: Text(
        context.res.strings.processOrderAfterVerify,
        textAlign: TextAlign.center,
        style: context.res.styles.caption2
            .copyWith(fontWeight: FontWeight.w400)
            .withLineHeight(18),
      ),
    );
  }
}
