part of 'cart_checkout_screen.dart';

// TODO (leovinsen): Rename as PageWrapper
// currently app router cannot generate routes from class names
// ending with PageWrapper. Will replace once page naming is streammlined.
class CartCheckoutScreenWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const CartCheckoutScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PaymentCheckoutCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<PaymentMethodCubit>()..queryPaymentMethods(),
        )
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CartCheckoutPage();
  }
}
