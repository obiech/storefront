part of '../product_item_card.dart';

/// Reusable list of product variants with
///
/// * Auto update of cart quantities.
/// * Display of variant detailed variant properties
/// * Action to add to cart & change quantity
class VariantsListView extends StatelessWidget {
  final ScrollController? controller;

  const VariantsListView({
    Key? key,
    required this.product,
    this.controller,
  }) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final variant = product.variants[index];
        return VariantTile(
          key: ValueKey('variant-${variant.sku}'),
          variant: variant,
          // TODO(obella): make sizing responsive
          trailing: SizedBox(
            width: 90,
            height: 35,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: .8,
              ),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int productQty = 0;
                  if (state is CartLoaded) {
                    final int itemIndex = state.cart.indexOfProduct(variant.id);

                    if (itemIndex > -1) {
                      productQty = state.cart.items[itemIndex].quantity;
                    }
                  }
                  return ProductAction(
                    product: variant,
                    productQuantity: productQty,
                  );
                },
              ),
            ),
          ),
        );
      },
      shrinkWrap: true,
      itemCount: product.variants.length,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
