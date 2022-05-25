part of '../cart_summary.dart';

/// Floating cart summary details
///
/// Created to simplify skeleton loading creation procedure
class CartSummaryDetails extends StatelessWidget {
  /// Set to true if the cart is loading
  /// Currently only prevents any actions on summary widgets
  final bool isLoading;

  /// Subtotal from [CartModel]
  final String subTotal;

  /// Toggle point when & when not to display discount
  final bool hasDiscount;

  /// Total from [CartModel]
  final String total;

  /// Number of items in cart
  final int itemCount;

  const CartSummaryDetails({
    Key? key,
    required this.isLoading,
    required this.subTotal,
    required this.hasDiscount,
    required this.total,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Row(
      children: [
        DropezyBadge(
          count: itemCount,
          icon: DropezyIcons.cart,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Row(
            children: [
              if (hasDiscount)
                Text(
                  subTotal.toCurrency(),
                  style: res.styles.discountText.copyWith(
                    color: res.colors.grey2,
                    fontSize: 12,
                  ),
                ),
              const SizedBox(
                width: 4,
              ),
              Text(
                total.toCurrency(),
                style: res.styles.productTileProductName.copyWith(
                  color: res.colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: .6,
            ),
            child: DropezyButton.primary(
              label: res.strings.viewCart,
              onPressed: () {
                if (!isLoading) context.router.push(const CartCheckoutRoute());
              },
              padding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        )
      ],
    );
  }
}
