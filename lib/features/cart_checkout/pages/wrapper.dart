part of 'cart_checkout_page.dart';

// currently app router cannot generate routes from class names
// ending with PageWrapper. Will replace once page naming is streammlined.
class CartCheckoutPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const CartCheckoutPageWrapper({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    getIt<PaymentMethodCubit>().queryPaymentMethods();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PaymentCheckoutCubit>(),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CartCheckoutPage();
  }
}
