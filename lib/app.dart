import 'package:flutter/material.dart';

import 'core/core.dart';
import 'core/theme.dart';

class AppWidget extends StatelessWidget {
  final AppRouter router;

  const AppWidget({Key? key, required this.router}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dropezy',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      routerDelegate: router.delegate(
        navigatorObservers: () => [NavigationObserver()],
      ),
      routeInformationParser: router.defaultRouteParser(),
    );
  }
}
