part of '../product_item_card.dart';

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

  /// Text style
  final TextStyle? textStyle;

  /// Badge Margin
  final EdgeInsets? margin;

  /// Badge Padding
  final EdgeInsets? padding;

  const ProductBadge({
    Key? key,
    required this.color,
    this.icon,
    required this.text,
    this.secondaryColor,
    this.scaleFactor = 1,
    this.margin,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  /// Flash Sale badge
  factory ProductBadge.flash(
    Resources res, {
    double scaleFactor = 1,
    EdgeInsets? margin,
    TextStyle? textStyle,
    EdgeInsets? padding,
  }) {
    return ProductBadge(
      icon: DropezyIcons.flash,
      color: res.colors.orange,
      text: 'Flash Sale',
      scaleFactor: scaleFactor,
      margin: margin,
      textStyle: textStyle,
      padding: padding,
    );
  }

  /// Best Seller badge
  factory ProductBadge.bestSeller(
    Resources res, {
    double scaleFactor = 1,
    EdgeInsets? margin,
    TextStyle? textStyle,
    EdgeInsets? padding,
  }) {
    return ProductBadge(
      icon: DropezyIcons.best_seller,
      color: res.colors.darkBlue,
      text: 'Best Seller',
      scaleFactor: scaleFactor,
      margin: margin,
      textStyle: textStyle,
      padding: padding,
    );
  }

  /// When stock drops below 4 items, a warning is displayed
  /// on the top right hand corner with remaining stock
  factory ProductBadge.stockWarning(
    Resources res,
    int stock, {
    double scaleFactor = 1,
    EdgeInsets? margin,
    TextStyle? textStyle,
    EdgeInsets? padding,
  }) {
    return ProductBadge(
      color: res.colors.lightOrange,
      secondaryColor: res.colors.orange,
      text: res.strings.stockLeft(stock),
      scaleFactor: scaleFactor,
      margin: margin,
      textStyle: textStyle,
      padding: padding,
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
      padding: padding ??
          EdgeInsets.symmetric(
            vertical: 3.5 * scaleFactor,
            horizontal: 4 * scaleFactor,
          ),
      margin: margin ?? EdgeInsets.all(4 * scaleFactor),
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
            style: (textStyle ?? const TextStyle(fontSize: 7)).copyWith(
              color: secondaryColor ?? res.colors.white,
            ),
          )
        ],
      ),
    );
  }
}
