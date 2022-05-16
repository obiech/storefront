part of '../cart_body_widget.dart';

/// Widget shown during [CartLoading].
///
/// Consists of a skeleton for
/// - Cart items list
/// - Payment summary
class CartBodyLoading extends StatelessWidget {
  const CartBodyLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CartItemsListLoading(),
        Divider(
          height: 1,
          color: context.res.colors.dividerColor,
        ),
        const SizedBox(height: 20),
        const OrderPaymentSummarySkeleton(),
      ],
    );
  }
}
