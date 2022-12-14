part of 'otp_verification_page.dart';

/// Wrapper for providing [AccountVerificationCubit] to
/// [OtpVerificationPage].
///
/// With this approach, [OtpVerificationPage] can be tested
/// separately from DI setup.
class OtpVerificationPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const OtpVerificationPageWrapper({
    Key? key,
    required this.phoneNumberIntlFormat,
    required this.successAction,
    required this.timeoutInSeconds,
    this.isRegistration = false,
  }) : super(key: key);

  final String phoneNumberIntlFormat;
  final int timeoutInSeconds;
  final OtpSuccessAction successAction;
  final bool isRegistration;

  @override
  Widget build(BuildContext context) => OtpVerificationPage(
        phoneNumberIntlFormat: phoneNumberIntlFormat,
        successAction: successAction,
        timeoutInSeconds: timeoutInSeconds,
        isRegistration: isRegistration,
      );

  @override
  Widget wrappedRoute(BuildContext context) {
    final authService = getIt<AuthService>();
    final customerRepository = getIt<ICustomerRepository>();

    return BlocProvider<AccountVerificationCubit>(
      create: (context) => AccountVerificationCubit(
        authService,
        customerRepository,
        isRegistration,
      )..sendOtp(phoneNumberIntlFormat),
      child: this,
    );
  }
}
