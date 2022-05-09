import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/features/cart_checkout/blocs/blocs.dart';

import '../../../core/shared_widgets/dropezy_scaffold.dart';
import '../../../di/injection.dart';
import '../widgets/widgets.dart';

class CartCheckoutPage extends StatelessWidget {
  const CartCheckoutPage({Key? key}) : super(key: key);
  static const routeName = '/cart-checkout';

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: 'Konfirmasi Belanja',
      childPadding: EdgeInsets.zero,
      child: Column(
        children: [
          const Expanded(
            child: CartBodyWidget(),
          ),
          BlocProvider(
            create: (context) => getIt<PaymentCheckoutCubit>(),
            child: const CartCheckout(
              price: '10300',
              discount: '12300',
              preferredPayment: 'OVO',
              points: '100',
            ),
          ),
        ],
      ),
    );
  }
}
