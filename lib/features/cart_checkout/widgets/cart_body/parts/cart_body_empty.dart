part of '../cart_body_widget.dart';

/// Shown when there is no items in the user's cart.
///
/// This situation could arise after deleting the last available item
/// in the user's cart.
class CartBodyEmpty extends StatelessWidget {
  const CartBodyEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;

    // width is roughly 42% of the screen size
    final imageSize = 0.42 * pageWidth;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.res.dimens.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              context.res.strings.cart,
              style: context.res.styles.caption1.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 20),
          SvgPicture.asset(
            context.res.paths.imageCart,
            key: CartBodyEmptyKeys.imageAsset,
            height: imageSize,
            width: imageSize,
          ),
          const SizedBox(height: 20),
          Text(
            context.res.strings.emptyCartTitle,
            style: context.res.styles.subtitle,
          ),
          const SizedBox(height: 8),
          Text(
            context.res.strings.emptyCartCaption,
            style: context.res.styles.caption2,
          ),
          const SizedBox(height: 16),
          DropezyButton.primary(
            label: context.res.strings.shopNow,
            key: CartBodyEmptyKeys.buttonShopNow,
            onPressed: () {
              context.router.popUntilRoot();
            },
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
