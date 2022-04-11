import 'package:auto_route/auto_route.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/di/injection.dart';

import '../../domain/services/auth_service.dart';
import '../../index.dart';
import 'otp_success_action.dart';

/// Otp Verification Route Wrapper
///
/// Otp verification [BlocProvider] doesn't solely depend on
/// [Singleton] to handle that we need a wrapper to generate the
/// [BlocProvider] this will be used for similar pages
/// and to de-clutter the main page with [MultiBlocProvider]
class OtpVerificationScreenWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const OtpVerificationScreenWrapper({
    Key? key,
    required this.phoneNumberIntlFormat,
    required this.successAction,
    required this.timeoutInSeconds,
    this.registerAccountAfterSuccessfulOtp = false,
  }) : super(key: key);

  final String phoneNumberIntlFormat;
  final int timeoutInSeconds;
  final OtpSuccessAction successAction;
  final bool registerAccountAfterSuccessfulOtp;

  @override
  Widget build(BuildContext context) => OtpVerificationScreen(
        phoneNumberIntlFormat: phoneNumberIntlFormat,
        successAction: successAction,
        timeoutInSeconds: timeoutInSeconds,
        registerAccountAfterSuccessfulOtp: registerAccountAfterSuccessfulOtp,
      );

  @override
  Widget wrappedRoute(BuildContext context) {
    final authService = getIt<AuthService>();
    final customerServiceClient = getIt<CustomerServiceClient>();

    return BlocProvider<AccountVerificationCubit>(
      create: (context) => AccountVerificationCubit(
        authService,
        customerServiceClient,
        registerAccountAfterSuccessfulOtp,
      )..sendOtp(phoneNumberIntlFormat),
      child: this,
    );
  }
}
