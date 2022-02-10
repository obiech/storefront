import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_app/bloc/account_availability/account_availability.dart';
import 'package:storefront_app/network/grpc/customer/customer.pbgrpc.dart';
import 'package:storefront_app/ui/otp_input/otp_input_screen.dart';
import 'package:storefront_app/ui/pin_input/pin_input_screen.dart';
import 'package:storefront_app/ui/screens.dart';

Route? appRouter(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      return _buildRoute(const HomeScreen());
    case OnboardingScreen.routeName:
      return _buildRoute(const OnboardingScreen());
    case RegistrationScreen.routeName:
      return _buildRoute(_buildRegistrationScreen());
    case LoginScreen.routeName:
      return _buildRoute(_buildLoginScreen());
    case OtpInputScreen.routeName:
      return _buildRoute(const OtpInputScreen());
    case PinInputScreen.routeName:
      return _buildRoute(const PinInputScreen());
    default:
      assert(false, 'Route \'${settings.name}\' is not implemented.');
      return null;
  }
}

Widget _buildRegistrationScreen() {
  final customerServiceClient = GetIt.I<CustomerServiceClient>();

  return BlocProvider<AccountAvailabilityCubit>(
    create: (_) => AccountAvailabilityCubit(customerServiceClient),
    child: const RegistrationScreen(),
  );
}

Widget _buildLoginScreen() {
  final customerServiceClient = GetIt.I<CustomerServiceClient>();

  return BlocProvider<AccountAvailabilityCubit>(
    create: (_) => AccountAvailabilityCubit(customerServiceClient),
    child: const LoginScreen(),
  );
}

/// Defines the default transition for all pages
Route _buildRoute(Widget screen) => CupertinoPageRoute(builder: (_) => screen);
