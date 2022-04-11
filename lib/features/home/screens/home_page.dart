import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'home';

  const HomePage({Key? key}) : super(key: key);

  //TODO: Implement HomeScreen
  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyScaffold.textTitle(
      title: 'Home',
      childPadding: const EdgeInsets.all(10),
      actions: [
        TextButton(
          onPressed: () {
            getIt<IPrefsRepository>().setIsOnBoarded(false);
            context.router.replaceAll([const OnboardingRoute()]);
          },
          child: Text(
            'Sign out',
            style: res.styles.caption1.copyWith(
              color: res.colors.white,
            ),
          ),
        )
      ],
      child: ListView(
        children: [
          ListTile(
            title: const Text('Cart Checkout'),
            onTap: () {
              context.router.push(const CartCheckoutRoute());
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Order History'),
            onTap: () {
              context.router.push(const OrderHistoryRoute());
            },
          ),
        ],
      ),
    );
  }
}
