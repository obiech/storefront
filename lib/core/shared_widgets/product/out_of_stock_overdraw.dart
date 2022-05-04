part of 'product_item_card.dart';

/// Filter to dim/gray out product item card
class OutOfStockOverdraw extends StatelessWidget {
  /// Filter border radius
  final double borderRadius;

  const OutOfStockOverdraw({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius,
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
