part of '../cart_checkout.dart';

class PriceAmountText extends StatelessWidget {
  final String price;

  const PriceAmountText({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      price.toCurrency(),
      style: context.res.styles.caption1.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
