part of '../product_tile.dart';

/// Shows discount percentage of a product
/// e.g. -33%
class DiscountTag extends StatelessWidget {
  @visibleForTesting
  const DiscountTag({
    Key? key,
    required this.discountPercentage,
  }) : super(key: key);

  final int discountPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 2.0,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFF9559),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        '-$discountPercentage%',
        style: context.res.styles.textSmall.copyWith(
          color: context.res.colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
