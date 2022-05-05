part of 'registration_screen.dart';

/// Wrapper for providing [AccountAvailabilityCubit] to
/// [RegistrationScreen].
///
/// With this approach, [RegistrationScreen] can be tested
/// separately from DI setup.
class RegistrationScreenWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const RegistrationScreenWrapper({
    Key? key,
    this.initialPhoneNumber,
  }) : super(key: key);

  final String? initialPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return RegistrationScreen(
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
