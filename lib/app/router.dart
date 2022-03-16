import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_app/bloc/account_availability/account_availability.dart';
import 'package:storefront_app/bloc/account_verification/account_verification_cubit.dart';
import 'package:storefront_app/bloc/pin/pin_registration.dart';
import 'package:storefront_app/constants/config/auth_config.dart';
import 'package:storefront_app/network/grpc/customer/customer.pbgrpc.dart';
import 'package:storefront_app/services/auth/auth_service.dart';
import 'package:storefront_app/services/auth/user_credentials_storage.dart';
import 'package:storefront_app/services/device/device_fingerprint_provider.dart';
import 'package:storefront_app/services/device/device_name_provider.dart';
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
      final String? phoneNumber = settings.arguments as String?;
      return _buildRoute(_buildRegistrationScreen(phoneNumber));
    case LoginScreen.routeName:
      final String? phoneNumber = settings.arguments as String?;
      return _buildRoute(_buildLoginScreen(phoneNumber));
    case OtpVerificationScreen.routeName:
      final OtpVerificationScreenArgs args =
          settings.arguments as OtpVerificationScreenArgs;

      return _buildRoute(_buildOtpInputScreen(args));
    case PinInputScreen.routeName:
      return _buildRoute(_buildPinInputScreen());
    default:
      assert(false, 'Route \'${settings.name}\' is not implemented.');
      return null;
  }
}

Widget _buildRegistrationScreen(String? initialPhoneNumber) {
  final customerServiceClient = GetIt.I<CustomerServiceClient>();

  return BlocProvider<AccountAvailabilityCubit>(
    create: (_) => AccountAvailabilityCubit(customerServiceClient),
    child: RegistrationScreen(
      initialPhoneNumber: initialPhoneNumber,
    ),
  );
}

Widget _buildLoginScreen(String? initialPhoneNumber) {
  final customerServiceClient = GetIt.I<CustomerServiceClient>();

  return BlocProvider<AccountAvailabilityCubit>(
    create: (_) => AccountAvailabilityCubit(customerServiceClient),
    child: LoginScreen(
      initialPhoneNumber: initialPhoneNumber,
    ),
  );
}

Widget _buildOtpInputScreen(OtpVerificationScreenArgs args) {
  final authService = GetIt.I<AuthService>();
  final customerServiceClient = GetIt.I<CustomerServiceClient>();

  return BlocProvider<AccountVerificationCubit>(
    create: (context) => AccountVerificationCubit(
      authService,
      customerServiceClient,
      args.registerAccountAfterSuccessfulOtp,
    )..sendOtp(args.phoneNumberIntlFormat),
    child: OtpVerificationScreen(
      phoneNumberIntlFormat: args.phoneNumberIntlFormat,
      successAction: args.successAction,
      timeoutInSeconds: AuthConfig.otpTimeoutInSeconds,
    ),
  );
}

Widget _buildPinInputScreen() {
  final deviceFingerprintProvider = GetIt.I<DeviceFingerprintProvider>();
  final deviceNameProvider = GetIt.I<DeviceNameProvider>();
  final customerServiceClient = GetIt.I<CustomerServiceClient>();
  final userCredentialsStorage = GetIt.I<UserCredentialsStorage>();

  return BlocProvider<PinRegistrationCubit>(
    create: (context) => PinRegistrationCubit(
      deviceFingerprintProvider: deviceFingerprintProvider,
      deviceNameProvider: deviceNameProvider,
      customerServiceClient: customerServiceClient,
      userCredentialsStorage: userCredentialsStorage,
    ),
    child: const PinInputScreen(),
  );
}

/// Defines the default transition for all pages
Route _buildRoute(Widget screen) => CupertinoPageRoute(builder: (_) => screen);
