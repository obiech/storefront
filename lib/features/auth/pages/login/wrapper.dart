part of 'login_page.dart';

/// Wrapper for providing [AccountAvailabilityCubit] to
/// [LoginPage].
///
/// With this approach, [LoginPage] can be tested
/// separately from DI setup.
class LoginPageWrapper extends StatelessWidget implements AutoRouteWrapper {
  const LoginPageWrapper({
    Key? key,
    this.initialPhoneNumber,
  }) : super(key: key);

  final String? initialPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      initialPhoneNumber: initialPhoneNumber,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountAvailabilityCubit>(),
      child: this,
    );
  }
}
