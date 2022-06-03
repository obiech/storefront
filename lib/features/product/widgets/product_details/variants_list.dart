import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

class VariantsList extends StatelessWidget {
  final ProductModel product;

  const VariantsList({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            res.strings.variants,
            style: res.styles.subtitle.withLineHeight(24),
          ),
          const SizedBox(
            height: 15,
          ),
          VariantsListView(product: product)
        ],
      ),
    );
  }
}
