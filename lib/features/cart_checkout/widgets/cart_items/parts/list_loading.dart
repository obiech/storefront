part of '../cart_items_section.dart';

class CartItemsListLoading extends StatelessWidget {
  const CartItemsListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (_, index) {
        return const ProductTileSkeleton();
      },
    );
  }
}
