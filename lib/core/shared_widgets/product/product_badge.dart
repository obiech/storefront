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

  /// Widget, Scale factor
  final double scaleFactor;

  const ProductBadge({
    Key? key,
    required this.color,
    this.icon,
    required this.text,
    this.secondaryColor,
    this.scaleFactor = 1,
  }) : super(key: key);

  /// Flash Sale badge
  factory ProductBadge.flash(
    Resources res, {
    double scaleFactor = 1,
  }) {
    return ProductBadge(
      icon: DropezyIcons.flash,
      color: res.colors.orange,
      text: 'Flash Sale',
      scaleFactor: scaleFactor,
    );
  }

  /// Best Seller badge
  factory ProductBadge.bestSeller(
    Resources res, {
    double scaleFactor = 1,
  }) {
    return ProductBadge(
      icon: DropezyIcons.best_seller,
      color: res.colors.darkBlue,
      text: 'Best Seller',
      scaleFactor: scaleFactor,
    );
  }

  /// When stock drops below 4 items, a warning is displayed
  /// on the top right hand corner with remaining stock
  factory ProductBadge.stockWarning(
    Resources res,
    int stock, {
    double scaleFactor = 1,
  }) {
    return ProductBadge(
      color: res.colors.lightOrange,
      secondaryColor: res.colors.orange,
      text: res.strings.stockLeft(stock),
      scaleFactor: scaleFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16 * scaleFactor),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 3.5 * scaleFactor,
        horizontal: 4 * scaleFactor,
      ),
      margin: EdgeInsets.all(4 * scaleFactor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: secondaryColor ?? res.colors.white,
              size: 8,
            ),
            SizedBox(
              width: 3 * scaleFactor,
            )
          ],
          Text(
            text,
            style: TextStyle(
              color: secondaryColor ?? res.colors.white,
              fontSize: 7,
            ),
          )
        ],
      ),
    );
  }
}
