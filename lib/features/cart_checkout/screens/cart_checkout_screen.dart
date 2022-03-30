import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/shared_widgets/dropezy_scaffold.dart';
import '../widgets/widgets.dart';

class CartCheckoutPage extends StatelessWidget {
  const CartCheckoutPage({Key? key}) : super(key: key);
  static const routeName = 'cart-checkout';

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: 'Konfirmasi Belanja',
      childPadding: 0,
      child: Column(
        children: const [
          Expanded(
            child: Center(child: Text('Checkout')),
          ),
          CartCheckout(
            price: '10300',
            discount: '12300',
            preferredPayment: 'OVO',
          )
        ],
      ),
    );
  }
}
