import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

/// Full text description of the product
class ProductDescription extends StatelessWidget {
  final ProductModel product;

  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      padding: EdgeInsets.all(context.res.dimens.spacingLarge),
      color: res.colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            res.strings.productDetails,
            style: res.styles.subtitle.withLineHeight(24),
          ),
          SizedBox(
            height: context.res.dimens.spacingMiddle,
          ),
          Text(
            product.description,
            style: res.styles.caption2
                .copyWith(color: res.colors.dropezyBlack)
                .withLineHeight(18),
          )
        ],
      ),
    );
  }
}
