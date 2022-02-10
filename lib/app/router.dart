import 'package:flutter/cupertino.dart';
import 'package:storefront_app/ui/screens.dart';

Route? appRouter(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      return _buildRoute(const HomeScreen());
    case OnboardingScreen.routeName:
      return _buildRoute(const OnboardingScreen());
    case RegistrationScreen.routeName:
      return _buildRoute(const RegistrationScreen());
    case LoginScreen.routeName:
      return _buildRoute(const LoginScreen());
    default:
      assert(false, 'Route \'${settings.name}\' is not implemented.');
      return null;
  }
}

/// Defines the default transition for all pages
Route _buildRoute(Widget screen) => CupertinoPageRoute(builder: (_) => screen);
