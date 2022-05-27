import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

/// Product details header.
///
/// Will have a carousel of images scrolling at top
/// and [MarketStatus] indicators at bottom left
class ProductDetailPageHeader extends StatefulWidget {
  /// Product to be displayed
  final ProductModel product;

  const ProductDetailPageHeader({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailPageHeader> createState() =>
      _ProductDetailPageHeaderState();
}

class _ProductDetailPageHeaderState extends State<ProductDetailPageHeader> {
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  /// Header aspect ratio (360x250) from figma design
  /// https://www.figma.com/file/1MehrTeZ2q50qqOO6XYvTR/Final-UI?node-id=6039%3A35816
  final _headerAspectRatio = 36 / 25;

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return AspectRatio(
      aspectRatio: _headerAspectRatio,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemBuilder: (BuildContext context, int index) {
                return CachedNetworkImage(
                  imageUrl: widget.product.imagesUrls[index],
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => Center(
                    child: Icon(
                      DropezyIcons.logo,
                      size: 90,
                      color: res.colors.lightBlue,
                    ),
                  ),
                );
              },
              itemCount: widget.product.imagesUrls.length,
              onPageChanged: (int index) => _currentPage.value = index,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 30.0, 23.0),
            child: Row(
              children: [
                if (widget.product.marketStatus != null)
                  widget.product.marketStatus == MarketStatus.FLASH_SALE
                      ? ProductBadge.flash(
                          res,
                          scaleFactor: 2,
                        )
                      : ProductBadge.bestSeller(
                          res,
                          scaleFactor: 2,
                        ),
                const Spacer(),
                ValueListenableBuilder<int>(
                  valueListenable: _currentPage,
                  builder: (_, value, __) {
                    return DotsIndicator(
                      position: value.toDouble(),
                      dotsCount: widget.product.imagesUrls.length,
                      decorator: DotsDecorator(
                        activeColor: res.colors.black,
                        color: res.colors.grey2,
                        size: const Size(5, 5),
                        activeSize: const Size(5, 5),
                        spacing: const EdgeInsets.only(
                          right: 5,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentPage.dispose();
    super.dispose();
  }
}
