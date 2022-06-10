part of '../cart_checkout.dart';

class CheckoutDetails extends StatelessWidget {
  const CheckoutDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded && !state.isCalculatingSummary) {
          final paymentSummary = state.cart.paymentSummary;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PriceAmountText(price: paymentSummary.total),
              if (state.cart.hasDiscount)
                SlashedAmountText(discount: paymentSummary.subTotal),
            ],
          );
        } else {
          return const CheckoutDetailSkeleton();
        }
      },
    );
  }
}
