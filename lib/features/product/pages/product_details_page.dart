import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../cart_checkout/index.dart';
import '../index.dart';

/// Display features and variants of a products
///
/// 1. Begins with a search app bar that opens the search page when tapped.
///
/// 2. Then a clear image of the product over a light-blue
/// background (Still under discussion). The image will be updated
/// to a carousel once multiple images can be provided by the backend
///
/// The image header also displays the [MarketStatus] of the product
/// with [MarketStatus.FLASH_SALE] badge and [MarketStatus.BEST_SELLER].
///
/// 3. Up next is a section with the product name with options to
/// like (Under review) & Share the product.
///
/// It will also contain a warning if the product is almost depleted.
///
/// 4. This section contains a detailed description of the product.
///
/// 5. Finally is a list of all the product variants with options to
/// add them to cart and change quantities.
///
/// The floating cart summary [CartSummary] closes the page with
/// detailed & real-time changes to the cart
class ProductDetailPage extends StatelessWidget {
  /// The product whose details are to be viewed
  final ProductModel productModel;

  const ProductDetailPage({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return DropezyScaffold(
      useRoundedBody: true,
      toolbarHeight: res.dimens.appBarSize + 20,
      bodyAlignment: Alignment.topCenter,
      title: GestureDetector(
        onTap: () => context.router.push(const GlobalSearchRoute()),
        child: SearchTextField(
          placeholder: res.strings.findYourNeeds,
          isEnabled: false,
        ),
      ),
      child: Container(),
    );
  }
}
