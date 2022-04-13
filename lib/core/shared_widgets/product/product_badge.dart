part of 'product_item_card.dart';

/// Flash/Bestseller float widget in product item
class ProductBadge extends StatelessWidget {
  /// Badge Color
  final Color color;

  /// Icon & Text Color
  final Color? secondaryColor;

  /// Badge Icon
  final IconData? icon;

  /// Badge text
  final String text;

  const ProductBadge({
    Key? key,
    required this.color,
    this.icon,
    required this.text,
    this.secondaryColor,
  }) : super(key: key);

  /// Flash Sale badge
  factory ProductBadge.flash(Resources res) {
    return ProductBadge(
      icon: DropezyIcons.flash,
      color: res.colors.orange,
      text: 'Flash Sale',
    );
  }

  /// Best Seller badge
  factory ProductBadge.bestSeller(Resources res) {
    return ProductBadge(
      icon: DropezyIcons.best_seller,
      color: res.colors.darkBlue,
      text: 'Best Seller',
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 3.5,
        horizontal: 4,
      ),
      margin: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: secondaryColor ?? res.colors.white,
              size: 13,
            ),
          Text(
            text,
            style: TextStyle(
              color: secondaryColor ?? res.colors.white,
              fontSize: 8,
            ),
          )
        ],
      ),
    );
  }
}
