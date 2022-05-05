part of 'otp_verification_screen.dart';

/// Wrapper for providing [AccountVerificationCubit] to
/// [OtpVerificationScreen].
///
/// With this approach, [OtpVerificationScreen] can be tested
/// separately from DI setup.
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
