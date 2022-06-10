part of '../cart_checkout.dart';

class SlashedAmountText extends StatelessWidget {
  final String discount;

  const SlashedAmountText({
    Key? key,
    required this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      discount.toCurrency(),
      style: context.res.styles.caption2.copyWith(
        decoration: TextDecoration.lineThrough,
      ),
    );
  }
}
