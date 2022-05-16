import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../di/injection.dart';
import '../../../features/cart_checkout/blocs/blocs.dart';
import '../widgets/widgets.dart';

part 'wrapper.dart';

// TODO: rename file to Page
class CartCheckoutPage extends StatelessWidget {
  const CartCheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.shoppingConfirmation,
      childPadding: EdgeInsets.zero,
      child: Column(
        children: const [
          Expanded(
            child: CartBodyWidget(),
          ),
          CartCheckout(
            price: '10300',
            discount: '12300',
            preferredPayment: 'OVO',
            points: '100',
          ),
        ],
      ),
    );
  }
}
