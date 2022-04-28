part of 'product_item_card.dart';

/// Filter to dim/gray out product item card
class OutOfStockOverdraw extends StatelessWidget {
  const OutOfStockOverdraw({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        res.dimens.spacingLarge,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: .5, sigmaY: .5),
        child: Container(
          color: res.colors.grey6.withOpacity(0.5),
          alignment: Alignment.center,
          child: const SizedBox(),
        ),
      ),
    );
  }
}
