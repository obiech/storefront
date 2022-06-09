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
          trailing: _VariantAction(variant: variant),
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

class _VariantAction extends StatefulWidget {
  const _VariantAction({
    Key? key,
    required this.variant,
  }) : super(key: key);

  final VariantModel variant;

  @override
  State<_VariantAction> createState() => _VariantActionState();
}

class _VariantActionState extends State<_VariantAction> {
  late ValueNotifier<bool> _isAtMaxQty;

  @override
  void initState() {
    super.initState();
    _isAtMaxQty = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO(obella): make sizing responsive
    final res = context.res;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
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
                  final int itemIndex =
                      state.cart.indexOfProduct(widget.variant.id);

                  if (itemIndex > -1) {
                    productQty = state.cart.items[itemIndex].quantity;
                  }
                }

                return ProductAction(
                  product: widget.variant,
                  productQuantity: productQty,
                  onMaxAvailableQtyChanged: (isAtMaxQty) async {
                    _isAtMaxQty.value = isAtMaxQty;

                    // Hide after 3 seconds
                    await Future.delayed(const Duration(seconds: 3));

                    _isAtMaxQty.value = false;
                  },
                );
              },
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isAtMaxQty,
          builder: (_, isAtMaxQty, __) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isAtMaxQty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          res.strings.maximumQty(widget.variant.maxQty ?? 0),
                          style: res.styles.textSmall
                              .copyWith(color: res.colors.red, fontSize: 8)
                              .withLineHeight(9.75),
                        )
                      ],
                    )
                  : const SizedBox(),
            );
          },
        )
      ],
    );
  }
}
