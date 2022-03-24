import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './config/auth_config.dart';
import '../di/injection.dart';
import '../features/auth/domain/services/auth_service.dart';
import '../features/auth/domain/services/user_credentials_storage.dart';
import '../features/auth/index.dart';
import '../features/home/index.dart';
import 'network/grpc/customer/customer.pbgrpc.dart';
import 'services/device/device_fingerprint_provider.dart';
import 'services/device/device_name_provider.dart';

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
          settings.arguments! as OtpVerificationScreenArgs;

      return _buildRoute(_buildOtpInputScreen(args));
    case PinInputScreen.routeName:
      return _buildRoute(_buildPinInputScreen());
    default:
      assert(false, "Route '${settings.name}' is not implemented.");
      return null;
  }
}

Widget _buildRegistrationScreen(String? initialPhoneNumber) {
  return BlocProvider<AccountAvailabilityCubit>(
    create: (_) => getIt<AccountAvailabilityCubit>(),
    child: RegistrationScreen(
      initialPhoneNumber: initialPhoneNumber,
    ),
  );
}

Widget _buildLoginScreen(String? initialPhoneNumber) {
  return BlocProvider<AccountAvailabilityCubit>(
    create: (_) => getIt<AccountAvailabilityCubit>(),
    child: LoginScreen(
      initialPhoneNumber: initialPhoneNumber,
    ),
  );
}

Widget _buildOtpInputScreen(OtpVerificationScreenArgs args) {
  final authService = getIt<AuthService>();
  final customerServiceClient = getIt<CustomerServiceClient>();

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
  final deviceFingerprintProvider = getIt<DeviceFingerprintProvider>();
  final deviceNameProvider = getIt<DeviceNameProvider>();
  final customerServiceClient = getIt<CustomerServiceClient>();
  final userCredentialsStorage = getIt<UserCredentialsStorage>();

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
