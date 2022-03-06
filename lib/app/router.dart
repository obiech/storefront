import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_app/bloc/account_availability/account_availability.dart';
import 'package:storefront_app/bloc/account_verification/account_verification_cubit.dart';
import 'package:storefront_app/constants/config/auth_config.dart';
import 'package:storefront_app/network/grpc/customer/customer.pbgrpc.dart';
import 'package:storefront_app/services/auth/auth_service.dart';
import 'package:storefront_app/ui/otp_verification/otp_verification.dart';
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
    case OtpVerificationScreen.routeName:
      final OtpVerificationScreenArgs args =
          settings.arguments as OtpVerificationScreenArgs;

      return _buildRoute(_buildOtpInputScreen(args));
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

Widget _buildOtpInputScreen(OtpVerificationScreenArgs args) {
  final authService = GetIt.I<AuthService>();
  final customerServiceClient = GetIt.I<CustomerServiceClient>();

  return BlocProvider<AccountVerificationCubit>(
    create: (context) =>
        AccountVerificationCubit(authService, customerServiceClient)
          ..sendOtp(args.phoneNumberIntlFormat),
    child: OtpVerificationScreen(
      phoneNumberIntlFormat: args.phoneNumberIntlFormat,
      successAction: args.successAction,
      timeoutInSeconds: AuthConfig.otpTimeoutInSeconds,
    ),
  );
}

/// Defines the default transition for all pages
Route _buildRoute(Widget screen) => CupertinoPageRoute(builder: (_) => screen);
