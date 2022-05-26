part of 'registration_page.dart';

/// Wrapper for providing [AccountAvailabilityCubit] to
/// [RegistrationPage].
///
/// With this approach, [RegistrationPage] can be tested
/// separately from DI setup.
class RegistrationPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const RegistrationPageWrapper({
    Key? key,
    this.initialPhoneNumber,
  }) : super(key: key);

  final String? initialPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return RegistrationPage(
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
