import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/core.dart';
import 'core/theme.dart';
import 'features/cart_checkout/blocs/cart/cart_bloc.dart';
import 'features/discovery/index.dart';

class AppWidget extends StatelessWidget {
  final AppRouter router;

  const AppWidget({Key? key, required this.router}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocListener<DiscoveryCubit, String?>(
      listener: (context, state) {
        // TODO (leovinsen): Think of a better approach, for example using Streams
        context.read<CartBloc>().add(LoadCart(state ?? ''));
      },
      child: MaterialApp.router(
        title: 'Dropezy',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: lightTheme,
        routerDelegate: router.delegate(
          navigatorObservers: () => [NavigationObserver()],
        ),
        routeInformationParser: router.defaultRouteParser(),
      ),
    );
  }
}
