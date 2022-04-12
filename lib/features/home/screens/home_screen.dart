import 'package:flutter/material.dart';
import 'package:storefront_app/core/shared_widgets/dropezy_scaffold.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/index.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  //TODO: Implement HomeScreen
  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: 'Home',
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartCheckoutPage()),
              );
            },
            child: const Text('CartCheckoutPage'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              );
            },
            child: const Text('OrderHistoryScreen'),
          ),
        ],
      ),
    );
  }
}
