part of 'login_screen.dart';

/// Wrapper for providing [AccountAvailabilityCubit] to
/// [LoginScreen].
///
/// With this approach, [LoginScreen] can be tested
/// separately from DI setup.
class LoginScreenWrapper extends StatelessWidget implements AutoRouteWrapper {
  const LoginScreenWrapper({
    Key? key,
    this.initialPhoneNumber,
  }) : super(key: key);

  final String? initialPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return LoginScreen(
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
